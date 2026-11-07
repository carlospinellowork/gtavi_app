#!/usr/bin/env python3
"""Robô de conteúdo do Vice Guide.

Monta o content.json que o app baixa:
  base.json      -> parte fixa (data, personagens, lugares, perguntas, checklist,
                    notícias e vídeos fixados à mão)
  sources.json   -> fontes automáticas (Google News pt-BR, feeds de canais do YouTube)
  content.json   -> arquivo anterior; o histórico de notícias e vídeos é mantido

Só usa a biblioteca padrão do Python. Só regrava o arquivo (e muda `version`)
quando o conteúdo mudou de verdade.

Uso: python3 update.py [--out content.json] [--offline]
"""
from __future__ import annotations

import argparse
import hashlib
import html
import json
import re
import sys
import unicodedata
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta, timezone
from email.utils import parsedate_to_datetime
from pathlib import Path

HERE = Path(__file__).resolve().parent
UA = "ViceGuideContentBot/1.0 (+https://github.com)"
ATOM = {"a": "http://www.w3.org/2005/Atom", "yt": "http://www.youtube.com/xml/schemas/2015"}

# Ordem importa: a primeira regra que bater define a etiqueta.
TAG_RULES = [
    ("Rumor", r"rumor|vazament|vaza|leak|insider|suposto|supostamente|teoria"),
    ("Trailer", r"trailer"),
    ("Preço", r"pre[çc]o|pr[ée]-?venda|r\$|us\$|edi[çc][ãa]o|vend"),
    ("Lançamento", r"lan[çc]amento|pr[ée]-?load|pr[ée]-?download|chega|data|faltam|dias para"),
    ("Gameplay", r"mapa|gameplay|miss[ãõo]|personage|carro|arma|m[úu]sica|r[áa]dio|trilha"),
]


def norm(text: str) -> str:
    text = unicodedata.normalize("NFKD", text.lower())
    text = "".join(c for c in text if not unicodedata.combining(c))
    return re.sub(r"[^a-z0-9]+", " ", text).strip()


def make_id(prefix: str, text: str) -> str:
    return f"{prefix}-{hashlib.sha1(norm(text).encode()).hexdigest()[:12]}"


def is_relevant(title: str, keywords: list[str]) -> bool:
    t = norm(title)
    return any(norm(k) in t for k in keywords)


def classify(title: str) -> str:
    t = title.lower()
    for tag, pattern in TAG_RULES:
        if re.search(pattern, t):
            return tag
    return "Notícia"


def iso(dt: datetime) -> str:
    return dt.astimezone(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def parse_iso(value: str | None) -> datetime | None:
    if not value:
        return None
    try:
        dt = datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        return None
    return dt if dt.tzinfo else dt.replace(tzinfo=timezone.utc)


# ─── Leitura das fontes ──────────────────────────────────────────────────────

def parse_google_news(xml_text: str, keywords: list[str], blocked: list[str]) -> list[dict]:
    root = ET.fromstring(xml_text)
    out = []
    blocked_n = {norm(b) for b in blocked}
    for item in root.iter("item"):
        raw_title = html.unescape(item.findtext("title") or "").strip()
        source_el = item.find("source")
        source = html.unescape(source_el.text or "").strip() if source_el is not None else ""
        # O Google acrescenta " - Fonte" no fim do título.
        title = raw_title
        if source and title.endswith(f" - {source}"):
            title = title[: -len(f" - {source}")].strip()
        if not title or not is_relevant(title, keywords) or norm(source) in blocked_n:
            continue
        try:
            date = parsedate_to_datetime(item.findtext("pubDate") or "")
        except (TypeError, ValueError):
            continue
        out.append({
            "id": make_id("n", title),
            "title": title,
            "summary": "",
            "source": source or "Google Notícias",
            "url": (item.findtext("link") or "").strip(),
            "date": iso(date),
            "tag": classify(title),
        })
    return out


def parse_youtube_feed(xml_text: str, keywords: list[str]) -> list[dict]:
    root = ET.fromstring(xml_text)
    channel = root.findtext("a:author/a:name", default="", namespaces=ATOM) or root.findtext("a:title", default="", namespaces=ATOM)
    out = []
    for entry in root.findall("a:entry", ATOM):
        vid = entry.findtext("yt:videoId", default="", namespaces=ATOM)
        title = html.unescape(entry.findtext("a:title", default="", namespaces=ATOM)).strip()
        published = parse_iso(entry.findtext("a:published", default="", namespaces=ATOM))
        if len(vid) != 11 or not is_relevant(title, keywords):
            continue
        out.append({
            "id": f"yt-{vid}",
            "title": title,
            "channel": channel,
            "youtubeId": vid,
            "date": iso(published) if published else "",
        })
    return out


def fetch(url: str) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept-Language": "pt-BR,pt;q=0.9"})
    with urllib.request.urlopen(req, timeout=20) as res:
        return res.read().decode("utf-8", errors="replace")


# ─── Montagem ────────────────────────────────────────────────────────────────

def _sort_key(item: dict) -> str:
    return item.get("date") or ""


def merge_news(pinned: list[dict], fresh: list[dict], previous: list[dict], *, now: datetime, max_items: int, max_age_days: int) -> list[dict]:
    by_id: dict[str, dict] = {}
    for item in previous + fresh:  # mesmo id (mesmo título): fica quem publicou primeiro
        old = by_id.get(item["id"])
        if old is None or _sort_key(item) < _sort_key(old):
            by_id[item["id"]] = item
    for item in pinned:  # fixados à mão sempre vencem
        by_id[item["id"]] = item
    cutoff = now - timedelta(days=max_age_days)
    pinned_ids = {p["id"] for p in pinned}
    kept = [
        n for n in by_id.values()
        if n["id"] in pinned_ids or (parse_iso(n.get("date")) or now) >= cutoff
    ]
    # Mesmo título em fontes diferentes: fica o primeiro (mais antigo = quem deu antes).
    seen, unique = set(), []
    for n in sorted(kept, key=_sort_key):
        key = norm(n["title"])[:70]
        if key in seen:
            continue
        seen.add(key)
        unique.append(n)
    return sorted(unique, key=_sort_key, reverse=True)[:max_items]


def merge_videos(pinned: list[dict], fresh: list[dict], previous: list[dict], *, max_items: int) -> list[dict]:
    by_vid: dict[str, dict] = {}
    for v in previous + fresh:
        by_vid[v["youtubeId"]] = v
    for v in pinned:
        by_vid[v["youtubeId"]] = v
    pinned_vids = {v["youtubeId"] for v in pinned}
    # O mesmo vídeo reenviado pelo canal (mesmo título): fica o primeiro envio.
    seen, unique = set(), []
    for v in sorted(by_vid.values(), key=lambda v: (v["youtubeId"] not in pinned_vids, _sort_key(v) or "9")):
        key = (norm(v.get("channel", "")), norm(v["title"]))
        if key in seen:
            continue
        seen.add(key)
        unique.append(v)
    dated = sorted((v for v in unique if v.get("date")), key=_sort_key, reverse=True)
    undated = [v for v in unique if not v.get("date")]
    return (dated + undated)[:max_items]


def build(base: dict, sources: dict, previous: dict, news: list[dict], videos: list[dict], *, now: datetime) -> dict:
    return {
        "releaseDate": base["releaseDate"],
        "platforms": base["platforms"],
        "news": merge_news(base.get("pinnedNews", []), news, previous.get("news", []), now=now,
                           max_items=sources.get("maxNews", 80), max_age_days=sources.get("maxNewsAgeDays", 60)),
        "videos": merge_videos(base.get("pinnedVideos", []), videos, previous.get("videos", []),
                               max_items=sources.get("maxVideos", 40)),
        "characters": base["characters"],
        "places": base["places"],
        "facts": base["facts"],
        "checklist": base["checklist"],
    }


def payload(content: dict) -> dict:
    return {k: v for k, v in content.items() if k not in ("version", "updatedAt")}


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(HERE / "content.json"))
    ap.add_argument("--offline", action="store_true", help="não busca nada na internet")
    args = ap.parse_args(argv)

    base = json.loads((HERE / "base.json").read_text())
    sources = json.loads((HERE / "sources.json").read_text())
    out = Path(args.out)
    previous = json.loads(out.read_text()) if out.exists() else {}
    keywords = sources["keywords"]
    now = datetime.now(timezone.utc)

    news, videos, errors = [], [], []
    if not args.offline:
        for url in sources.get("googleNews", []):
            try:
                news += parse_google_news(fetch(url), keywords, sources.get("blockedSources", []))
            except Exception as e:  # uma fonte fora do ar não derruba as outras
                errors.append(f"news {url[:60]}: {e}")
        for ch in sources.get("youtubeChannels", []):
            try:
                videos += parse_youtube_feed(fetch(f"https://www.youtube.com/feeds/videos.xml?channel_id={ch['id']}"), keywords)
            except Exception as e:
                errors.append(f"youtube {ch['name']}: {e}")

    content = build(base, sources, previous, news, videos, now=now)
    for e in errors:
        print("aviso:", e, file=sys.stderr)
    print(f"{len(news)} notícias e {len(videos)} vídeos lidos; {len(content['news'])} notícias e {len(content['videos'])} vídeos no arquivo")

    if previous and payload(previous) == content:
        print("sem mudanças")
        return 0
    final = {"version": int(now.strftime("%Y%m%d%H%M")), "updatedAt": iso(now), **content}
    out.write_text(json.dumps(final, ensure_ascii=False, indent=2) + "\n")
    print(f"gravado {out} (version {final['version']})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
