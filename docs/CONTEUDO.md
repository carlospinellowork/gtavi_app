# Como atualizar o conteúdo

O app lê `content.json` de `https://raw.githubusercontent.com/carlospinellowork/neon-guide-content/main/content.json`.

## Montar uma vez
1. Criar no GitHub o repositório **público** `neon-guide-content`.
2. Copiar `assets/content/content.json` deste repo para a raiz dele.
3. Criar ali um `PRIVACY.md` (modelo abaixo). A loja exige link de política de privacidade.

## Cada atualização
1. Editar o `content.json` (no próprio site do GitHub dá).
2. **Aumentar `version`** (1 → 2 → 3...). O app ignora arquivo remoto com versão menor que a que já tem.
3. Atualizar `updatedAt`.
4. De vez em quando, copiar o arquivo para `assets/content/content.json` aqui, para quem instala sem internet já ver o conteúdo novo.

O GitHub leva até ~5 min para servir a versão nova. O app busca ao abrir e quando se puxa a tela para baixo.

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
> O Neon Guide não pede cadastro e não coleta dados pessoais. O progresso do checklist fica salvo só no seu aparelho. O app baixa um arquivo de conteúdo do GitHub, que pode registrar o endereço IP da requisição, como qualquer site. Contato: <seu e-mail>.
