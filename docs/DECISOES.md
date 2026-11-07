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
- **Decisão:** um `content.json` num repo **público** (`carlospinellowork/leonida-hub-content`); o app baixa ao abrir e guarda cópia; sem internet usa o embutido.
- **Por quê:** grátis, sem servidor, e permite atualizar notícias e checklist sem nova revisão das lojas.

## 2026-11-07 Memória em docs/ no repositório
- **Decisão:** `CLAUDE.md` + `docs/` no git, em vez de um vault no Obsidian.

## 2026-11-07 Juntar o trabalho de ago–set (commits c78a4af..ccff1b3)
- **Ficou:** vídeos verificados via oEmbed (Extended Look, trailer BR, reações de criadores) e o compartilhamento (card de contagem como imagem, notícias como texto).
- **Saiu:** screenshots oficiais espelhados do rockstarintel.com (marca), rádios de internet com streams HTTP de terceiros (fora do foco e licença incerta), player do YouTube embutido (abrir no YouTube basta) e os agentes/skill `new-feature` que mandavam criar dados especulativos.
- Imagens geradas por IA continuam fora, como você já tinha decidido.

## 2026-11-07 Nome: Vice Guide (não Neon Guide) — substituída abaixo
- **Decisão do Carlos:** o app se chamaria **Vice Guide**, pacote `com.viceguide.app`.

## 2026-11-07 Conteúdo 100% automático
- **Pedido do Carlos:** não atualizar notícias e vídeos à mão.
- **Decisão:** robô em Python (`content-bot/`) rodando no GitHub Actions a cada 30 min. Lê o Google Notícias em pt-BR (só títulos com GTA 6/VI, com fonte e link, etiqueta "Rumor" para vazamentos) e os feeds dos canais do YouTube (Rockstar, Rockstar Brasil, IGN Brasil, Flow, Cellbit, BRKsEDU), mantém histórico de 60 dias e publica o `content.json`. Sem IA paga, sem servidor, custo zero.
- **À mão (raro):** `base.json`: data, personagens, lugares, perguntas, checklist, e notícias e vídeos fixados.
- Os builds do app rodam o robô antes de compilar, então quem instala já vê o conteúdo do dia.

## 2026-11-07 Nome final: Leonida Hub
- **Contexto:** o Carlos sugeriu "Vice Rock Guide". Recomendei não usar: "Vice" + "Rock" lembra Vice City + Rockstar e cai na política de falsa identidade do Google Play.
- **Decisão do Carlos:** **Leonida Hub** (Leonida é o estado do jogo). Pacote `com.leonidahub.app` (Android e iOS), repositório de conteúdo `leonida-hub-content`.
- **Regras:** "guia não oficial" no título da loja; nunca "GTA", "Rockstar" nem "Vice City" no nome ou no ícone.

## 2026-11-07 Monetização
- **Decisão do Carlos ("deixar tudo pronto"):** AdMob (banner fixo + tela cheia com limite de frequência) com consentimento LGPD/GDPR (UMP); compra única "Remover anúncios"; links de afiliado da Amazon no checklist, com aviso.
- IDs de teste do Google até ele criar as contas; os IDs reais ficam todos em `lib/core/constants/monetization.dart`.
