---
name: new-feature
description: Scaffold a brand-new feature module end-to-end in gtavi_app (model, mock repository, screen(s), DI wiring, routing, tests). Use for "add a new section/tab/catalog for X", "cria uma feature nova para X".
---

# New feature scaffold — gtavi_app

This orchestrates a full vertical slice for a new feature, in this order, delegating the actual file-writing to the `flutter-feature-builder` agent (and `flutter-test-writer` for tests) so the result matches project conventions exactly.

## 1. Clarify scope before generating anything

Confirm with the user (don't guess on architecturally significant points):

- Feature name (English identifier, e.g. `bounties`) and its display name in Portuguese.
- List-only, or list + detail screen?
- Does it belong in the bottom-tab shell (`/home`, `/explore`, `/map`, `/progress`, `/profile`) or as a standalone pushed route reachable from elsewhere (like `characters`, `vehicles`, etc. currently are)?
- Is it favoritable (goes through `favoritesStateProvider`)?
- A rough shape for its mock data fields (or point to the closest existing feature to mirror, e.g. "like vehicles but for boats" → just reuse vehicles' shape).

## 2. Scaffold

Delegate to the `flutter-feature-builder` agent with the confirmed scope: domain model → mock repository → screen(s) → provider registration in `lib/app/providers.dart` → route registration in `lib/app/router/app_router.dart`.

## 3. Tests

Delegate to the `flutter-test-writer` agent to add `test/<feature>_repository_test.dart` covering the new mock repository's filtering/lookup behavior.

## 4. Verify

Run the `check` skill (`flutter analyze` + `flutter test`) if the Flutter SDK is available in this environment; otherwise list what still needs manual verification.

## 5. Report

Summarize the files created/changed and any decision that was made without explicit user input (e.g. a chosen icon/color) so it can be revisited.
