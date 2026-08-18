# gtavi_app

Companion/fan app para o GTA VI (Grand Theft Auto VI) escrito em Flutter. Todo o conteúdo (notícias, veículos, personagens, missões etc.) é **especulativo/fictício**, feito para fins de entretenimento — vale manter esse tom ao gerar novo conteúdo.

## Stack

- **Flutter** (Dart SDK ^3.13.0), Material 3, tema único dark (`AppTheme.darkTheme`).
- **flutter_riverpod** ^2.6 — providers + `StateNotifier` para estado.
- **go_router** ^17 — navegação declarativa, com `StatefulShellRoute.indexedStack` para as 5 abas principais.
- **dio** — `ApiClient` já configurado (`lib/core/network/api_client.dart`), mas **nenhum repositório real o usa ainda** — é o ponto de integração futuro com um backend real.
- **shared_preferences** / **flutter_secure_storage** — via `StorageService` (`lib/core/storage/storage_service.dart`).
- **cached_network_image** — carrega imagens reais via rede com cache local (ver `AppNetworkImage` abaixo).
- **youtube_player_iframe** — player de vídeo do YouTube embutido de verdade (trailers e vídeos de criadores reais).
- **just_audio** — playback de áudio real para as estações de rádio (streams de internet reais, não a trilha licenciada do jogo).
- Sem backend: 100% dos repositórios são `Mock*Repository` com listas em memória e `Future.delayed` simulando latência.

## Conteúdo visual real (não gerado por IA)

O app não empacota imagens geradas por IA como conteúdo "oficial". Todo conteúdo visual real é carregado via rede e cacheado localmente:

- **`AppNetworkImage`** (`lib/core/widgets/app_network_image.dart`) — widget padrão para qualquer imagem real (`imageUrl`), com placeholder e fallback de erro tratados. Use-o em vez de `Image.asset`/`Image.network` direto.
- **`GtaViRealMedia`** (`lib/core/constants/gtavi_real_media.dart`) — URLs reais verificadas (thumbnails oficiais do YouTube, screenshots oficiais da Rockstar) para usar como `imageUrl` quando um item não tem uma foto real própria (ex.: personagens principais, hero banners). Adicione novas constantes ali em vez de espalhar URLs mágicas pelos repositórios.
- Para vídeos: `thumbnailUrl` de qualquer vídeo real do YouTube pode ser `https://i.ytimg.com/vi/{id}/hqdefault.jpg` (sempre funciona para vídeo público, sem precisar de scraping/API key).
- Quando não existe imagem real para um item (ex.: um veículo fictício do catálogo), deixe `imageUrl: ''` — `AppNetworkImage` mostra um placeholder neutro. Nunca finja uma imagem real com asset gerado por IA.
- Vídeos reais (trailers oficiais + criadores de conteúdo) devem ser verificados via `https://www.youtube.com/oembed?url=...&format=json` antes de entrar no repositório mock — título/canal vêm do oEmbed, nunca inventados. `duration`/`viewsCount` ficam vazios/zerados quando não há como confirmar o valor real (oEmbed não expõe isso sem API key).

## Arquitetura (feature-first)

```
lib/
  app/            # bootstrap: app.dart, router, theme, providers.dart (DI global)
  core/            # constants, errors, network, storage, widgets de design system, services
  features/<nome>/
    data/          # <nome>_repository.dart — interface abstrata + Mock<Nome>Repository
    domain/        # <nome>_model.dart — modelo imutável (const, copyWith, toJson/fromJson)
    presentation/  # <nome>_screen.dart (+ _detail_screen.dart quando há detalhe)
```

Cada feature é autocontida; only `lib/app/providers.dart` (DI) e `lib/app/router/app_router.dart` (rotas) conhecem todas as features.

Features existentes: home, explore, map, progress, profile (abas do shell) + characters, vehicles, weapons, locations, missions, guides, news, videos, radio, cheats, economy, gallery, easter_eggs, favorites, search, ai_chat.

## Convenções de código

- **Modelo** (`domain/*_model.dart`): classe imutável, campos `final`, construtor `const`, sempre com `copyWith`, `toJson`, `fromJson`.
- **Repositório** (`data/*_repository.dart`): interface abstrata pública + `Mock<Nome>Repository implements` com dados fixos em português e `await Future.delayed(...)` antes de retornar.
- **Provider de DI**: cada repositório tem um `Provider<XRepository>` em `lib/app/providers.dart` que retorna a implementação Mock.
- **Tela de listagem**: `ConsumerWidget`, filtros/busca como `StateProvider` locais na própria tela, combinados num `FutureProvider` que lê o repositório + os filtros (ver `filteredVehiclesProvider` em `vehicles_screen.dart` como referência).
- **Design system** (reusar sempre, não recriar): `AppColors`, `AppSpacing`, `AppTypography` (`lib/app/theme/`) e `GlassCard`, `AppBadge`, `AppButton`, `AppEmptyState`, `AppLoadingState`, `StatBar` (`lib/core/widgets/`).
- **Estados assíncronos**: sempre tratar `loading` (→ `AppLoadingState`), `error` (→ `AppEmptyState` com ícone de erro) e `data` vazio (→ `AppEmptyState`) — nunca deixar uma tela sem os três casos.
- **Rotas**: `context.push('/feature')` e `context.push('/feature/$id')`; registrar em `app_router.dart` tanto a rota de listagem quanto a de detalhe.
- **Idioma**: texto de UI e dados mock em português (pt-BR); nomes de código (classes, variáveis) em inglês.
- **Favoritos**: qualquer entidade "favoritável" usa `favoritesStateProvider` (`toggleFavorite(id)`) — não criar um mecanismo de favoritos paralelo por feature.
- **Player de vídeo real**: `VideoPlayerScreen` usa `youtube_player_iframe` (`YoutubePlayerController.fromVideoId` + widget `YoutubePlayer`) para tocar o vídeo real embutido, sempre com um botão "Abrir no YouTube" (`url_launcher`) como fallback manual.
- **Player de rádio real**: `RadioPlayerController` (`lib/features/radio/presentation/radio_player_controller.dart`) é um `StateNotifier` que encapsula um único `just_audio` `AudioPlayer` compartilhado por toda a tela — trocar de estação faz `setUrl` + `play` nesse mesmo player. Não crie um `AudioPlayer` por estação/widget.

## Testes

- `test/*_repository_test.dart` — testam os `Mock*Repository` isoladamente (ver `vehicles_repository_test.dart`, `missions_repository_test.dart`).
- `test/widget_test.dart` — smoke test do app inteiro via `ProviderScope` com `SharedPreferences.setMockInitialValues({})`.
- Rodar: `flutter test`.

## Comandos

```
flutter pub get              # instalar dependências
flutter analyze              # lint (flutter_lints, ver analysis_options.yaml)
flutter test                 # testes
flutter run -d chrome        # rodar no navegador (mais rápido para iterar)
flutter run -d windows       # rodar como app desktop Windows
flutter build apk            # build Android (ver .github/workflows/android_build.yml)
```

> Neste ambiente o Flutter SDK não estava instalado/no PATH da máquina até a última verificação — confirme com `flutter --version` antes de assumir que os comandos acima funcionam direto.

## CI

- `.github/workflows/android_build.yml` e `ios_build.yml` — builds automatizados.

## Agents e skills do projeto

- `.claude/agents/flutter-feature-builder.md` — cria uma feature nova completa seguindo as convenções acima.
- `.claude/agents/flutter-code-reviewer.md` — revisa código Dart/Flutter quanto a convenções do projeto, Riverpod e boas práticas.
- `.claude/agents/flutter-test-writer.md` — escreve/atualiza testes de repositório e widget seguindo o padrão existente.
- `.claude/skills/new-feature/` — `/new-feature` orquestra o agent de scaffold ponta a ponta (model → repo → provider → tela → rota).
- `.claude/skills/check/` — `/check` roda analyze + test (+ format) antes de commit.
- `.claude/skills/run/` — instruções de projeto para o skill genérico `run` (build/rodar o app).
