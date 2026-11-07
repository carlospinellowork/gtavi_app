# Como atualizar o conteúdo

O app lê `content.json` de `https://raw.githubusercontent.com/carlospinellowork/vice-guide-content/main/content.json`.

## Automático (robô)
Notícias e vídeos se atualizam sozinhos. O robô (`content-bot/update.py`) roda no GitHub Actions a cada 30 min:
- **Notícias:** Google Notícias pt-BR, só títulos que citam GTA 6/VI, com fonte e link. Vazamentos recebem a etiqueta "Rumor". Ficam 60 dias, no máximo 80.
- **Vídeos:** feeds dos canais em `content-bot/sources.json` (Rockstar, Rockstar Brasil, IGN Brasil, Flow, Cellbit, BRKsEDU), só vídeos que citam o jogo. Reenvio com o mesmo título aparece uma vez.
- Só publica quando muda; `version` vira data e hora (AAAAMMDDhhmm).
- Testes sem internet: `cd content-bot && python3 -m unittest -v`. Rodar na mão: `python3 update.py --out ../assets/content/content.json`.

**À mão (raro):** `content-bot/base.json` (data, personagens, lugares, perguntas, checklist, notícias e vídeos fixados) e `sources.json` (adicionar canal, bloquear fonte em `blockedSources`).

## Montar uma vez (o Carlos)
1. Criar no GitHub o repositório **público** e **vazio** `vice-guide-content`.
2. O Claude envia para lá o conteúdo de `content-bot/` (robô + workflow `.github/workflows/update-content.yml`) e um `PRIVACY.md`.
3. Em Settings → Actions → General: "Read and write permissions".

Enquanto isso não existe, o app usa o conteúdo embutido, que os builds do CI atualizam rodando o robô antes de compilar.

## Campos
- `news[]`: `id`, `title`, `summary`, `source`, `url`, `date` (AAAA-MM-DD), `tag`. **Sempre com fonte real.**
- `videos[]`: `id`, `title`, `channel`, `youtubeId`, `date`.
- `characters[]`, `places[]`, `facts[]` (`q`, `a`).
- `checklist[]`: grupos com `items[]` (`id`, `title`, `note` opcional). **Nunca mudar o `id` de um item já publicado**: o progresso das pessoas é salvo por id.

## Pendências de conteúdo (07/11)
- Conferir no canal da Rockstar se saiu um trailer de lançamento (uma fonte diz 15/10/2026) e o vídeo "Extended Look" (27/08/2026) e, se confirmados, adicionar em `videos` com o ID do YouTube.
- Conferir o ID do Trailer 2 (`VQRLujxTm3c`) abrindo o link.
- Depois de 19/11: grupos de checklist com missões e colecionáveis reais.

## Modelo de PRIVACY.md
> O Vice Guide não pede cadastro e não coleta dados pessoais. O progresso do checklist fica salvo só no seu aparelho. O app baixa um arquivo de conteúdo do GitHub, que pode registrar o endereço IP da requisição, como qualquer site. Contato: <seu e-mail>.
