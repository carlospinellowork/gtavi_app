---
name: run
description: Build and run gtavi_app (Flutter). Use for "run the app", "start the app", "rode o app", or to verify a change works in the real app. Project-specific override consumed by the general-purpose `run` skill.
---

# Running gtavi_app

This is a Flutter app with no backend — all data is served by in-memory `Mock*Repository` classes, so `flutter pub get` + a device target is all that's needed.

## 0. Confirm the Flutter SDK is actually available

`flutter` is not guaranteed to be on `PATH` in every environment this repo is opened in. Check first:

```
flutter --version
```

If that fails, **say so explicitly** and stop — don't fall back to `dart` alone or claim the app "ran" without a real Flutter toolchain. Ask the user whether to install the SDK (`git clone -b stable https://github.com/flutter/flutter.git`, add `<clone>/bin` to `PATH`) or whether they'll run it in their own environment.

## 1. Install dependencies

```
flutter pub get
```

## 2. Pick a target and run

```
flutter devices          # see what's actually available
```

- Fastest to iterate on / easiest to screenshot: `flutter run -d chrome`
- Windows desktop (needs Visual Studio "Desktop development with C++" workload): `flutter run -d windows`
- Android emulator/device (needs Android SDK + a running emulator or attached device): `flutter run -d <device-id>`

For a one-shot check rather than a live hot-reload session, `flutter build web` / `flutter build apk` compiles without needing a persistent process — better suited to a non-interactive tool call.

## 3. Sanity-check before/instead of a full run

If a full run isn't feasible (no display, no emulator, SDK missing), these still validate the app compiles and behaves correctly:

```
flutter analyze
flutter test
```

## Known constraints

- `flutter run` is a long-lived interactive process (hot reload) — when driving it from a non-interactive tool, prefer `run_in_background` and then interact via the app's URL (web) rather than expecting the command to return.
- The app starts at `/splash` then redirects into the tab shell at `/home` — if verifying a specific feature, navigate via the app's own UI/routes rather than assuming the splash screen is the final state.
