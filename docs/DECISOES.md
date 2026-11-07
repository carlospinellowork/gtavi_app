# Decisões

## 2026-11-07 Reformular o app para o lançamento
- **Contexto:** o app tinha 25 telas e conteúdo quase todo inventado (notícias com citações falsas, cheats, armas, missões, economia, rádios, "agente de IA" fixo no código, vídeos falsos de canais reais).
- **Decisão:** app enxuto com 4 abas: contagem regressiva, notícias reais, guia do que é oficial e checklist. Saíram chat de IA, cheats, armas, missões, veículos, economia, rádio, easter eggs, galeria, mapa, perfil, busca e favoritos.
- **Por quê:** conteúdo falso reprova na loja ("conteúdo enganoso") e acaba com a confiança; o valor real vem depois do lançamento (guias e checklist com dados reais).

## 2026-11-07 Nome próprio e aviso de app não oficial
- **Decisão:** nome "Neon Guide — guia não oficial", sem "GTA" no nome ou no ícone, sem arte da Rockstar. Retratos de IA imitando Lucia e Jason e o "mapa" inventado foram removidos.
- **Por quê:** as lojas barram marca de terceiros e a Take-Two derruba apps de fãs.
- **Ainda dá para trocar o nome:** `AppConstants.appName`, `AndroidManifest.xml`, `ios/Runner/Info.plist`.

## 2026-11-07 Conteúdo via JSON no GitHub
- **Decisão:** um `content.json` num repo **público** (`carlospinellowork/neon-guide-content`); o app baixa ao abrir e guarda cópia; sem internet usa o embutido.
- **Por quê:** grátis, sem servidor, e permite atualizar notícias e checklist sem nova revisão das lojas.

## 2026-11-07 Memória em docs/ no repositório
- **Decisão:** `CLAUDE.md` + `docs/` no git, em vez de um vault no Obsidian.
