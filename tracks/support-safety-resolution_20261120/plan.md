# T-17 Delivery Plan

## Implemented

- [x] Define support categories, submission state, reporter identity, evidence
  references, idempotency key, and submission audit event.
- [x] Add local persisted, Firestore, and fallback repository adapters.
- [x] Add role-scoped case creation and participant reads in Firestore rules;
  prohibit client review edits and deletion.
- [x] Add customer reporting for active and completed persisted bookings.
- [x] Add artisan reporting for the assigned active job.
- [x] Explain safety reporting limits, review expectations, and local/demo-only
  persistence state in the app.
- [x] Run `flutter analyze lib`; no issues found.

## Pending dependencies and launch work

- [ ] Merge T-13 and connect warranty arbitration to the support-case record.
- [ ] Deliver T-19's trusted admin queue, audited decision workflow, and
  participant-visible resolution reasons.
- [ ] Configure support contact details and an urgent escalation path.
- [ ] Add private file upload, evidence authorization, retention, and deletion
  policy before accepting image/document evidence.
- [ ] Validate Firestore rules and transactions with the Firebase emulator.
