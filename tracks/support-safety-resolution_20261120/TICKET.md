# T-17 — Customer and Artisan Safety, Support and Resolution

**Status:** In progress; implementation ready for review
**Branch:** `codex/T-17-customer-artisan-safety-support-resolution`
**Baseline:** T-16 merged in PR #12 (`4adfba7`)

## Delivered in this branch

- Added a booking-linked support case model with issue categories for no-show,
  property damage, safety, service quality, warranty, cancellation, payment,
  and other concerns.
- Added a submission audit event and a stable idempotency key. The Firestore
  adapter creates a case transactionally; the local adapter persists cases
  across app restarts.
- Added customer reporting from active and completed persisted bookings and an
  artisan reporting action from the active-job screen.
- Restricted Firestore case creation to the booking's customer or assigned,
  approved artisan. Other booking participants and admins can read the report;
  client updates and deletion are denied.
- The report form explains that filing is not claim approval and marks that it
  is not an emergency line. In local/demo mode, the UI says the report stays on
  the device and has not reached support.
- Evidence is represented as up to five HTTPS references. The app has no
  configured file picker or Firebase Storage upload flow, so it does not claim
  that photos or files have been uploaded.

## Dependencies and remaining handoff

- T-13 remains marked `pushed, PR ready`; its warranty arbitration UI is still
  client-side and is not yet connected to these immutable support cases.
- T-19's operations console has not started. This branch deliberately denies
  client review updates; T-19 must add trusted review transitions and expose
  decision reasons to the case participants.
- No support phone/email is configured in the app. A direct contact channel
  and secure file upload/storage policy remain launch requirements.
- The current status values prepare the client for review updates, but this
  branch only submits reports; operators cannot resolve them yet.

## Verification

`flutter analyze lib` reports no issues. Automated tests and Firebase emulator
checks were not run in this delivery pass.
