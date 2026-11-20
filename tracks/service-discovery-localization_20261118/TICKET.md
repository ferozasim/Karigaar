# T-14: Task-First Discovery & App-Wide Localization

**Status:** Pushed (PR not opened)
**Current branch:** `codex/T-14-localization-completion`
**Base:** `origin/main` at `c50cc80` (initial T-14 search and locale work merged)

## Problem

Homeowners often know the repair or material they need, not the marketplace's trade name. A tile or granite request is currently buried inside Mason / Civil Worker. The app also exposes a language control only in parts of the artisan portal; the app shell and homeowner flows do not follow it.

## Scope

1. Search jobs, materials, package names, trade names, and English/Marathi aliases, then route to the existing canonical trade ID.
2. Present task-oriented labels while preserving the original trade as the provider category and booking contract.
3. Add one persisted English/Hindi/Marathi locale shared across homeowner and artisan experiences.
4. Move visible app copy, form validation, loading/empty/error states, and dynamic service data to localization resources; cover both roles.
5. Keep service search and locale selection offline-first, and keep the catalog replaceable by a backend taxonomy API later.

## Design and architecture

- `ServiceDiscoveryCatalog` maps query vocabulary to existing trade IDs; it does not introduce duplicate provider identities or alter booking schemas.
- Search ranking runs on the client against the loaded trade catalog and is safe when offline.
- A single locale provider owns app language; `MaterialApp` consumes it and persists it locally.
- ARB files are the source of UI translations, with English, Hindi, and Marathi supported.
- Backend integration can later source the same canonical IDs, task taxonomy, and localized labels without changing the customer flow.

## Acceptance criteria

- Searching for tile/flooring and granite/marble/stone surfaces the masonry provider and its relevant service label.
- Searching by a trade name, package name, or supported Marathi term continues to find the expected provider.
- Selecting a result navigates with the existing canonical trade ID.
- Language can be changed from both homeowner settings and artisan profile, applies app-wide, and persists after restart.
- Visible customer and artisan text, including dialogs, validation, empty/error states, and dynamic service labels, follows the selected language.
- Architecture, project status, and this ticket document reflect the shipped behavior and remaining work.
- Run formatter, analyzer, tests, and a mobile build before merging; do not push while checks fail.

## Progress

- [x] Isolated branch from current `main` baseline.
- [x] Added initial task alias search and a task-oriented homeowner search sheet.
- [x] Added the app locale controller, persistence, and initial English/Hindi/Marathi ARB copy.
- [x] Localized login, role switcher, and key homeowner home labels and validation in English, Hindi, and Marathi. Preserved English copy used by established flows.
- [x] Added an English fallback for isolated widget previews/tests without localization delegates and Hindi/Marathi entry tests.
- [x] Connected the shared language setting to artisan registration and localized the OTP, onboarding, locality selector, urgent dispatch banner, artisan active job, and shared loading copy.
- [x] Added a repeatable localization assembly step that merges catalog, booking, customer account, and onboarding/artisan resources into the English, Hindi, and Marathi ARB files before `flutter gen-l10n`.
- [x] Localized booking filter labels and selected catalog-driven trade labels in artisan onboarding while preserving canonical trade IDs in registration data.
- [x] Ran `dart format` on the changed Dart files and `flutter test --no-pub --reporter=compact`; all 368 tests passed.
- [x] Built the Android debug APK with `flutter build apk --debug --no-pub` (Gradle reported `Built build\\app\\outputs\\flutter-apk\\app-debug.apk`).
- [x] Verified `flutter analyze --no-pub`; it reports no issues.
- [x] Reran the full mobile suite after the English trade-label compatibility fix; all 368 tests passed.
- [x] Rebuilt the Android debug APK after the final localization and analyzer fixes. This Windows environment cannot produce an iOS build.
