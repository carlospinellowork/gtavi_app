# Como atualizar o conteúdo

O app lê `assets/content/content.json` deste repositório (público) por `https://raw.githubusercontent.com/carlospinellowork/gtavi_app/main/assets/content/content.json`.

## Automático (robô)
Notícias e vídeos se atualizam sozinhos. O robô (`content-bot/update.py`) roda no GitHub Actions a cada 30 min:
- **Notícias:** Google Notícias pt-BR, só títulos que citam GTA 6/VI, com fonte e link. Vazamentos recebem a etiqueta "Rumor". Ficam 60 dias, no máximo 80.
- **Vídeos:** feeds RSS dos canais (se o feed cair, o que o YouTube faz às vezes por horas, o robô lê a página do canal em pt-BR; a data fica aproximada e nunca substitui uma exata), listados em `content-bot/sources.json` (Rockstar, Rockstar Brasil, IGN Brasil, Flow, Cellbit, BRKsEDU), só vídeos que citam o jogo. Reenvio com o mesmo título aparece uma vez.
- Só publica quando muda; `version` vira data e hora (AAAAMMDDhhmm).
- Testes sem internet: `cd content-bot && python3 -m unittest -v`. Rodar na mão: `python3 update.py --out ../assets/content/content.json`.

**À mão (raro):** `content-bot/base.json` (data, personagens, lugares, perguntas, checklist, notícias e vídeos fixados) e `sources.json` (adicionar canal, bloquear fonte em `blockedSources`).

## Onde roda
- Workflow `.github/workflows/update-content.yml` neste repositório: a cada 30 min (e quando `base.json`, `sources.json` ou `update.py` mudam). Para rodar na hora: Actions → "Atualizar conteúdo" → Run workflow.
- O robô só faz commit em `assets/content/content.json`; esses commits não disparam o build do Android e do iOS.
- Por isso, **antes de dar push no repositório, sempre `git pull --rebase`**: o robô terá feito commits.
- Política de privacidade: `PRIVACY.md` na raiz (link em Sobre).

## Campos
- `news[]`: `id`, `title`, `summary`, `source`, `url`, `date` (AAAA-MM-DD), `tag`. **Sempre com fonte real.**
- `videos[]`: `id`, `title`, `channel`, `youtubeId`, `date`.
- `characters[]`, `places[]`, `facts[]` (`q`, `a`).
- `checklist[]`: grupos com `items[]` (`id`, `title`, `note`, `link` e `linkLabel` opcionais; links da Amazon ganham o ID de afiliado no app). **Nunca mudar o `id` de um item já publicado**: o progresso das pessoas é salvo por id.

## Pendências de conteúdo (07/11)
- Conferir no canal da Rockstar se saiu um trailer de lançamento (uma fonte diz 15/10/2026) e o vídeo "Extended Look" (27/08/2026) e, se confirmados, adicionar em `videos` com o ID do YouTube.
- Conferir o ID do Trailer 2 (`VQRLujxTm3c`) abrindo o link.
- Depois de 19/11: grupos de checklist com missões e colecionáveis reais.

## Modelo de PRIVACY.md
> O Leonida Hub não pede cadastro. Exibe anúncios do Google AdMob, que pode usar o ID de publicidade do aparelho e dados de uso conforme a política do Google (https://policies.google.com/technologies/ads); você pode rever o consentimento em Sobre → Privacidade dos anúncios. Compras são processadas pela Google Play / App Store. O progresso do checklist fica salvo só no seu aparelho. O app baixa um arquivo de conteúdo do GitHub, que pode registrar o endereço IP da requisição, como qualquer site. Contato: <seu e-mail>.
