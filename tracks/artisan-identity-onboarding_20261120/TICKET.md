# T-15 — Karigaar Identity, Login and Onboarding

**Status:** In progress
**Branch:** `codex/T-15-artisan-identity-onboarding`
**Baseline:** T-14 merged in PR #10 (`b51b63a`)

## Goal

Give artisans a clear, resumable path to verify a phone identity, complete
onboarding, and understand their review status. Keep customer and artisan
sessions separate and prevent unapproved accounts from opening work screens.

## Delivery in this branch

- Added a named development phone-auth adapter with an explicit demo code. It
  creates a stable local user ID from the normalized phone so sign-in resolves
  to the same identity.
- Added a serializable onboarding draft with a stable artisan record key and
  `draft`, `submitted`, `needsAction`, `approved`, and `rejected` review states.
- Persisted only resumable profile fields in SharedPreferences. OTP, Aadhaar,
  bank account, and payout secrets are not written to the draft.
- Routed submitted applicants to an application status page and wrapped
  customer and artisan destinations in role-aware gates. Artisan work routes
  additionally require an approval claim from the identity adapter and an
  approved application state.
- Removed registration's direct promotion of unreviewed form data into the
  public artisan profile.
- Added callable functions for phone-verified application submission and
  admin-only review transitions. Decisions write an audit event and update the
  artisan approval custom claim; approval creates a profile with verification
  flags still false.
- Tightened Firestore rules for user records, private artisan applications,
  review history, public artisan profiles, and broadcast-job acceptance.

## Boundary and remaining live integration

The development adapter never issues artisan approval. The mobile app still
uses its local draft/status store and does not call the new Firebase Functions;
the admin portal's current approval buttons remain demo-only. Wire those clients
to Firebase Phone Auth and the callable review flow before production use. The
server functions and Firestore rules define the trusted boundary, but they have
not been exercised against the Firebase emulator in this pass.

## Verification

`dart analyze` on the changed Dart files: no issues found. TypeScript
`tsc --noEmit`: no issues found. Automated tests and Firebase emulator checks
were not run in this delivery pass.
