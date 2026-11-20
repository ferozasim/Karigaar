# T-16 — Reliable Booking and Dispatch Lifecycle

**Status:** In progress on `codex/T-16-reliable-booking-dispatch`.
**Baseline:** T-15 merged in PR #11 (`b0854b2`).

**Business goal:** Make the core customer promise dependable from service selection through completed work.

**Scope:** Connect service selection, problem description and media, scheduling, booking confirmation, artisan assignment, ETA/status updates, reassignment, completion, cancellation, and failed-dispatch recovery.

## Acceptance criteria

- Booking states and permitted transitions are defined in one domain contract and enforced server-side when live backend is enabled.
- Customer and artisan see consistent status and schedule information after refresh or reconnect.
- Duplicate submission/retry does not create duplicate bookings or dispatches.
- Unfulfilled dispatch and artisan cancellation have a defined recovery path and customer-facing update.
- A booking can be resumed after app restart and operator intervention is auditable.

**Architecture boundary:** Booking aggregate owns lifecycle state; dispatch service owns offer/acceptance; notification service sends updates. Avoid keeping authoritative booking state only in Riverpod or a widget.

**Dependencies:** T-14, T-15, and T-19.

## Implementation and verification

- Added a role-aware booking transition contract, status audit records, idempotent repository transitions, and a `dispatchFailed` retry state.
- Added transactional Firestore creation/transitions and Firestore rules restricting booking writes to valid audited changes.
- Added local booking persistence and repository streams; wired booking creation, customer tracking, and artisan assignment to them.
- Added issue description and persisted schedule/audio/photo attachment metadata to bookings.
- Synced T-15's approval claims and identity link into the booking security rules and audit actor IDs.
- Routed artisan arrival, work start, invoice submission, and completion through audited repository transitions; direct unreviewed state changes no longer pass through the booking mirror.
- `flutter analyze --no-pub`: passed.
- T-16 lifecycle, booking model, service scoping, and radar widget tests: passed (43 tests).
- Firestore emulator validation could not run because the available Java runtime is below the Firebase CLI's required JDK 21.

After syncing the merged T-15 baseline, `dart analyze lib` passed again. Automated tests and Firebase emulator validation have not been rerun during this continuation.
