---
name: check
description: Run gtavi_app's static checks (analyze, format, test) before considering a change done or before committing. Use for "check", "roda os testes", "valida antes de commitar".
---

# Project health check — gtavi_app

Run in this order and report real output for each (don't summarize as "passed" without showing what ran):

```
flutter analyze
dart format --output=none --set-exit-if-changed lib test
flutter test
```

- If `flutter` isn't available in this environment, say so explicitly instead of skipping silently — this blocks all three steps.
- `flutter analyze` must be clean against `analysis_options.yaml` (`flutter_lints`) — fix warnings rather than suppressing them with `// ignore:` unless there's a genuine false positive.
- If `dart format` reports files needing formatting, run `dart format lib test` to fix them rather than hand-editing whitespace.
- `flutter test` covers `test/*_repository_test.dart` (mock repository behavior) and `test/widget_test.dart` (app smoke test). A failing smoke test after a routing/provider change usually means `lib/app/providers.dart` or `lib/app/router/app_router.dart` wasn't updated to match — check those first.
