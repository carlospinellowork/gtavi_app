"""Testes do robô sem internet: python3 -m unittest -v (dentro de content-bot/)."""
import unittest
from datetime import datetime, timezone

import update

GNEWS = """<?xml version="1.0"?><rss><channel>
<item><title>GTA 6 terá mais de 200 GB - Estadão</title><link>https://news.google.com/a1</link>
<pubDate>Tue, 03 Nov 2026 17:15:00 GMT</pubDate><source url="https://estadao.com.br">Estadão</source></item>
<item><title>GTA 6 terá mais de 200 GB - Exame</title><link>https://news.google.com/a2</link>
<pubDate>Wed, 04 Nov 2026 10:00:00 GMT</pubDate><source url="https://exame.com">Exame</source></item>
<item><title>Vazamento sugere modo online em GTA VI - Site X</title><link>https://news.google.com/a3</link>
<pubDate>Thu, 05 Nov 2026 10:00:00 GMT</pubDate><source url="https://x.com">Site X</source></item>
<item><title>Novo Zelda anunciado - IGN</title><link>https://news.google.com/a4</link>
<pubDate>Thu, 05 Nov 2026 10:00:00 GMT</pubDate><source url="https://ign.com">IGN</source></item>
<item><title>GTA 6 &amp; pré-venda bate recorde - Fonte Ruim</title><link>https://news.google.com/a5</link>
<pubDate>Thu, 05 Nov 2026 11:00:00 GMT</pubDate><source url="https://ruim.com">Fonte Ruim</source></item>
</channel></rss>"""

YT = """<?xml version="1.0"?><feed xmlns="http://www.w3.org/2005/Atom" xmlns:yt="http://www.youtube.com/xml/schemas/2015">
<title>Rockstar Games</title><author><name>Rockstar Games</name></author>
<entry><yt:videoId>AAAAAAAAAAA</yt:videoId><title>Grand Theft Auto VI Launch Trailer</title><published>2026-10-15T15:00:00+00:00</published></entry>
<entry><yt:videoId>BBBBBBBBBBB</yt:videoId><title>GTA Online: Heist Update</title><published>2026-10-20T15:00:00+00:00</published></entry>
</feed>"""

KW = ["gta 6", "gta vi", "grand theft auto vi"]
NOW = datetime(2026, 11, 7, tzinfo=timezone.utc)


class GoogleNewsTest(unittest.TestCase):
    def setUp(self):
        self.items = update.parse_google_news(GNEWS, KW, ["Fonte Ruim"])

    def test_filtra_irrelevantes_e_bloqueadas(self):
        titles = [i["title"] for i in self.items]
        self.assertNotIn("Novo Zelda anunciado", titles)
        self.assertFalse(any("recorde" in t for t in titles))

    def test_tira_fonte_do_titulo_e_classifica(self):
        rumor = next(i for i in self.items if "Vazamento" in i["title"])
        self.assertEqual(rumor["title"], "Vazamento sugere modo online em GTA VI")
        self.assertEqual(rumor["source"], "Site X")
        self.assertEqual(rumor["tag"], "Rumor")
        self.assertEqual(rumor["date"], "2026-11-05T10:00:00Z")

    def test_mesmo_titulo_em_duas_fontes_fica_uma_vez(self):
        merged = update.merge_news([], self.items, [], now=NOW, max_items=80, max_age_days=60)
        gb = [n for n in merged if "200 GB" in n["title"]]
        self.assertEqual(len(gb), 1)
        self.assertEqual(gb[0]["source"], "Estadão")  # quem publicou primeiro


class YoutubeTest(unittest.TestCase):
    def test_so_videos_do_jogo(self):
        vids = update.parse_youtube_feed(YT, KW)
        self.assertEqual([v["youtubeId"] for v in vids], ["AAAAAAAAAAA"])
        self.assertEqual(vids[0]["channel"], "Rockstar Games")

    def test_reenvio_com_mesmo_titulo_aparece_uma_vez(self):
        a = {"id": "yt-A", "youtubeId": "AAAAAAAAAAA", "title": "Launch Trailer", "channel": "R", "date": "2026-10-15T15:00:00Z"}
        b = {**a, "id": "yt-B", "youtubeId": "BBBBBBBBBBB", "date": "2026-10-16T15:00:00Z"}
        merged = update.merge_videos([], [a, b], [], max_items=40)
        self.assertEqual([v["youtubeId"] for v in merged], ["AAAAAAAAAAA"])


class MergeTest(unittest.TestCase):
    def test_historico_fixados_e_validade(self):
        pinned = [{"id": "p1", "title": "Fixada antiga", "date": "2025-01-01", "source": "", "url": "", "summary": "", "tag": ""}]
        old = {"id": "n-old", "title": "Velha GTA 6", "date": "2026-08-01T00:00:00Z"}
        prev = {"id": "n-prev", "title": "Anterior GTA 6", "date": "2026-11-01T00:00:00Z"}
        merged = update.merge_news(pinned, [], [old, prev], now=NOW, max_items=80, max_age_days=60)
        ids = [n["id"] for n in merged]
        self.assertIn("p1", ids)       # fixada nunca expira
        self.assertIn("n-prev", ids)   # histórico mantido
        self.assertNotIn("n-old", ids)  # passou de 60 dias

    def test_sem_mudanca_nao_regrava(self):
        base = {"releaseDate": "2026-11-19", "platforms": [], "characters": [], "places": [], "facts": [], "checklist": []}
        content = update.build(base, {}, {}, [], [], now=NOW)
        previous = {"version": 1, "updatedAt": "x", **content}
        self.assertEqual(update.payload(previous), update.build(base, {}, previous, [], [], now=NOW))


if __name__ == "__main__":
    unittest.main()
