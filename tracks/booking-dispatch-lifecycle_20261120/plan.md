# T-16 implementation notes

## Delivered

- Central transition map and per-transition actor checks.
- Idempotency keys and actor/time/reason audit events.
- Atomic Firestore booking creation and status transitions.
- Firestore rules for owner-scoped reads, valid state changes, and audit records.
- SharedPreferences local booking persistence plus repository observation streams.
- Service scoping creates a booking from selected trade, locality, problem description, media memo, and arrival slot.
- Artisan claim advances through claimed, assigned, and en-route; failed local dispatch can be retried by the customer.
- Customer tracking and artisan active-job screens observe persisted booking state.

## Verification

- `flutter analyze --no-pub`: passed.
- Targeted lifecycle, booking model, scoping, and radar tests: passed (43 tests).
- `git diff --check`: passed.
- Firestore emulator check is pending an available JDK 21 runtime.

## Follow-up before production use

- T-19 operations remains a dependency from the source backlog.
- Firestore rules still need emulator validation before enabling live booking writes.
