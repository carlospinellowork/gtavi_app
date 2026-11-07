# Leonida Hub (repo gtavi_app)

App Flutter de fã, **não oficial**, para o GTA 6 (lançamento 19/11/2026). Conversa e textos em pt-BR.

## Como trabalhar aqui (mesmo jeito do Nexo)
- **Verificar antes de dizer que terminou**: `flutter analyze` e `flutter test` limpos; olhar as telas (build web + print em 412px).
- **Commit e push a cada parte pronta** na `main` (o GitHub Actions gera o APK e o IPA). Citar os hashes no relatório.
- **Decisões do Carlos** viram entrada em `docs/DECISOES.md` (data, decisão, por quê).
- **Fim de sessão com trabalho feito**: atualizar `docs/PLANO.md` (feito / pendente).
- Propor antes de alargar o escopo. O app é enxuto de propósito.

## Regras do produto (não negociáveis)
- **Nada inventado.** Notícia só com fonte e link real; personagem e lugar só o que foi revelado oficialmente; cheat, missão e colecionável só depois do lançamento, conferidos.
- **Marca**: sem "GTA" no nome ou no ícone das lojas, sem arte oficial da Rockstar, sem retratos imitando os personagens. O aviso de "app de fã, não oficial" fica sempre visível (Início e Sobre).
- Vídeos: só link para o YouTube de quem publicou; nunca hospedar nem baixar vídeo. Antes de entrar no `content.json`, verificar título e canal via `https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=<id>&format=json`. Data só se confirmada (campo `date` opcional).
- **Nenhuma imagem gerada por IA** e nenhum screenshot oficial espelhado (risco de marca). Visual = tema, degradês e ícones.

## Arquitetura
- Conteúdo = `assets/content/content.json` (embutido) + mesmo arquivo remoto em `AppConstants.contentUrl` (repo público). Gerado pelo robô `content-bot/` (Python, sem dependências; testes: `python3 -m unittest` dentro da pasta). Notícias e vídeos nunca à mão. Ver `docs/CONTEUDO.md`.
- `lib/features/content/` modelos e repositório (cache → embutido → remoto); `lib/app/providers.dart` (Riverpod).
- Compartilhar (`lib/core/services/share_service.dart`, share_plus): card da contagem vira imagem; notícia vira texto com link. É o motor de divulgação grátis.
- Monetização (`lib/features/monetization/`, IDs em `lib/core/constants/monetization.dart`): AdMob com consentimento UMP, banner acima das abas, tela cheia só ao SAIR de um vídeo e no máximo 1 a cada 3 min; compra única `remover_anuncios` (in_app_purchase); `affiliateUrl()` para links da Amazon. Tudo desligado no web e nos testes (`monetizationSupported`).
- Abas: Início (contagem regressiva), Notícias (+ vídeos), Guia (essencial, personagens, lugares), Checklist. Tela Sobre (`/sobre`).
- Flutter não está instalado globalmente; há um SDK baixado no scratchpad da sessão, ou use o CI.

## Comandos e skills
- `flutter pub get` · `flutter analyze` · `flutter test` · `flutter build web` (prints) · `flutter build apk`
- `.claude/skills/check` (analyze + format + test) e `.claude/skills/run` (rodar e tirar prints).
