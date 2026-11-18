# T-14: Task-First Discovery & App-Wide Localization

**Status:** In progress  
**Branch:** `feat/T-14-service-discovery-localization`  
**Base:** `origin/main` at `90e97d7`

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
- [ ] Complete localization coverage across all app screens and dynamic content.
- [ ] Verify analyzer, tests, and Android/iOS build.
