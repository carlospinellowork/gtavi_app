# Plano até o lançamento (19/11/2026)

## Feito em 07/11
- Reformulação: de 25 telas inventadas para 4 abas com conteúdo verificado (ver `DECISOES.md`).
- Conteúdo remoto com cache offline; contagem regressiva; checklist salvo no aparelho; tela Sobre com aviso e política de privacidade.

## Feito em 07/11 (tarde)
- Conteúdo 100% automático (`content-bot/`), com plano B quando o feed do YouTube cai (lê a página do canal).
- Vídeos tocam dentro do app.
- Nome **Leonida Hub**, pacote `com.leonidahub.app`.
- Monetização pronta com IDs de TESTE: banner, tela cheia ao sair de vídeo (no máximo 1 a cada 3 min), consentimento LGPD/GDPR, "Remover anúncios" (compra única) e afiliados da Amazon no checklist.

## Próximos passos (em ordem)
1. **Google Play Console** (US$ 25, uma vez): criar a conta; começar já o teste fechado (12 testadores × 14 dias).
2. **AdMob** (grátis): criar o app "Leonida Hub" e 2 blocos de anúncio (banner adaptativo e intersticial), para Android e iOS. Trocar os IDs em `lib/core/constants/monetization.dart`, no `AndroidManifest.xml` e no `Info.plist`. Em "Privacidade e mensagens", criar a mensagem de consentimento (GDPR) — sem ela o formulário não aparece.
3. **Produto "Remover anúncios"** no Play Console: Monetizar → Produtos → Produtos no app, ID `remover_anuncios`, compra única (sugestão R$ 9,90). Só funciona depois que um build estiver no teste fechado.
4. **Amazon Associados** (grátis): cadastrar e colocar o ID (ex.: `leonidahub-20`) em `Monetization.amazonTag`.
5. ~~Repo de conteúdo~~ feito: o próprio `gtavi_app` ficou público (07/11). `PRIVACY.md` na raiz.
6. Ícone próprio, prints da loja, build `.aab` assinado no CI (a Play não aceita APK).
7. Ficha da loja: "Leonida Hub: guia não oficial", marcar "Contém anúncios", preencher "Segurança dos dados" (ID de publicidade coletado pelo AdMob).
8. **Apple** (US$ 99/ano) depois do Android dar sinal de vida.
9. **Depois de 19/11**: checklist de missões e colecionáveis reais.
