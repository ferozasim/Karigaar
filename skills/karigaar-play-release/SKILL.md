---
name: karigaar-play-release
description: Use this skill whenever Asim asks to take Karigaar toward production, prepare or publish its Flutter Android app on Google Play, fix Play policy or release blockers, harden the app for real users, or plan the next production step. Treat him as the sole developer: make the work incremental and achievable by one person, prioritize a small Nanded pilot, and avoid team-sized plans or unnecessary infrastructure.
---

# Karigaar production and Google Play release

Help the solo developer move the existing Karigaar Flutter marketplace from demo/client-side behavior to a safe, supportable Android pilot and a compliant Google Play release. Work from the repository's actual state each time; old status reports can be stale. Separate implemented UI, tested behavior, configured infrastructure, deployed services, and verified production behavior.

## Working style for a solo developer

- Keep work small, ordered, and reviewable. Recommend one high-value vertical slice at a time, with a clear completion check.
- Prefer the existing Flutter + Firebase architecture and managed services when they fit. Avoid adding microservices, new vendors, elaborate CI, or paid tools without a concrete need.
- Scope the first real release to the Nanded pilot. Defer expansion, advanced automation, and low-priority polish until core customer and artisan workflows work end to end.
- Assume one person is coding, testing, operating the pilot, and communicating with testers. Provide realistic weekly effort and point out calendar waits such as Play's closed-test period.
- Do not delegate to agents unless Asim asks. Do not invent a team, budget, credentials, or available testers.
- Preserve existing work and inspect `git status` before edits. Follow repository instructions. Do not expose or commit secrets, signing keys, real customer records, or KYC documents.
- When asked to change code, complete the authorized, bounded change. Run tests/builds only when Asim asks for verification or the task specifically requires it; otherwise report the checks that should be run without claiming they passed.

## Start with a current baseline

Inspect, as relevant:

- `tracks.md`, current ticket files and `git status` for current work and local changes.
- `apps/mobile_app/android/app/build.gradle` for application ID, target SDK, release signing, version code/name, and bundle configuration.
- `apps/mobile_app/android/app/src/main/AndroidManifest.xml` for permissions, exported components, and intent filters.
- `apps/mobile_app/pubspec.yaml`, Firebase initialization, auth/function clients, repository adapters, and route guards.
- `firebase.json`, `.firebaserc`, Firestore/Storage rules, Cloud Functions, emulator configuration, and deployment notes.
- Privacy/account deletion links and screens, Play listing materials, CI/release scripts, and Android release artifacts.

Do not treat a project ID in `.firebaserc`, a source function, a passing mock test, or an APK file as proof that a backend is deployed or the app is production-ready. State what the repo proves and what still requires Play Console, Firebase Console, provider credentials, a physical device, or the developer to confirm.

Known baseline from the inspected repository (re-check before using):

- Flutter Android application ID is `in.karigaar.app`.
- Android `targetSdkVersion` is currently 34; the release build currently uses the debug signing configuration.
- The manifest requests fine/coarse location, camera, microphone, legacy external storage, media images, and notifications. Confirm each permission is truly needed; minimize or remove unneeded access.
- Firebase config, rules, repository adapters, and Functions source exist, but the Flutter entry point does not initialize Firebase and the client lacks Firebase Auth/Functions dependencies. T-15 also documents that clients still use demo/local flows.
- T-13 warranty/dispute state remains a client-side prototype, according to its ticket.
- The app uses phone numbers, location, audio, photos, and onboarding/KYC-related fields; account deletion and Data safety declarations must reflect actual collection, use, sharing, and retention.

## Verify current Google Play policy

Play policies and target API deadlines change. Before stating a deadline, exact API level, testing rule, payment rule, or account requirement, browse current official Google Play Console / Android documentation. Prefer official Google sources; do not rely on old project notes or search snippets alone. See [references/google-play-sources.md](references/google-play-sources.md) as a starting index and open the relevant current source.

Determine the developer account type and creation date from the user or Play Console if available. If unknown, identify which rules depend on that fact rather than assuming. For a new personal developer account created after 13 November 2023, Google's current help page requires at least 12 testers continuously opted into a closed test for 14 days before applying for production access. Build this calendar wait into the plan and recruit real, representative testers early; do not suggest fake or purchased testers.

Review at least these areas for a Play release:

1. Current target API requirement and Android compatibility.
2. Signed release Android App Bundle, secure upload key, unique package ID, versioning, and release build configuration. Never ship a debug-signed release.
3. Developer identity and package registration requirements shown in Play Console.
4. App content declarations: Data safety, privacy policy, content rating, target audience, ads, app access/reviewer instructions, and financial/features declarations where applicable.
5. A public, accessible privacy policy linked in both the store listing and app.
6. Account deletion: a discoverable in-app request path and an external web request URL when users can create accounts; delete associated data subject to clearly disclosed lawful retention.
7. Sensitive data and permissions: phone/authentication data, precise location, photos, camera, microphone/audio, financial data, and KYC data. Explain collection/use/sharing; show any required prominent disclosure and obtain affirmative consent before the sensitive access/permission request. Prefer foreground-only location and Android Photo Picker/document picker where suitable. Avoid background location unless essential and policy-approved.
8. Billing classification: distinguish payment for physical home services from digital app functionality, subscriptions, or content. Verify the current Payments policy for each offer (including any membership, lead unlock, or subscription) before choosing a payment flow; do not make a blanket assumption.
9. Play's required testing track for this account, tester engagement, production-access application, pre-launch report, staged rollout, and post-release monitoring.

Treat store-policy compliance as a product/data-flow review, not only a Gradle setting. Compare the manifest, SDK behavior, privacy policy, Data safety answers, in-app disclosures, and actual backend behavior so they agree.

## Karigaar production sequence

Keep the order dependency-aware. A different order is fine only when repository evidence explains why.

### Gate 1 — Release baseline and scope

- Choose a limited Nanded pilot and list exactly which real workflows are in scope.
- Record blockers, facts needing console/account confirmation, and existing local changes.
- Check current Play API requirements; establish a production-ready target and secure signing plan.
- Create/confirm separate Firebase staging and production environments before real personal data is used.
- Remove or clearly disable demo-only affordances that could be mistaken for real identity, payment, warranty, or job state.

### Gate 2 — Identity and trusted access

- Initialize Firebase explicitly and connect real phone authentication and callable Functions.
- Finish T-15 application submission, admin review, audit history, and approval-aware route gates.
- Enforce authorization server-side; client route guards are user experience, not a security boundary.
- Provide safe sign-out, session recovery, support contact, and account/data deletion paths.

### Gate 3 — Core marketplace vertical slice

- Make one booking flow real end to end: customer creates a service request; backend validates and stores it; approved artisans can discover/claim it safely; both sides see status updates; cancellation/failure is handled.
- Enforce status transitions, idempotency, and ownership checks on trusted backend paths.
- Persist the minimum profile, booking, and dispatch data needed for the Nanded pilot. Keep location collection minimal and foreground/user-initiated where possible.
- Use Firebase Emulator Suite for local backend/rules development if practical; do not require paid deployment to iterate.

### Gate 4 — Trust, money, and provider integrations

- Persist T-13 reviews, claims, decisions, reserve accounting, and audit history.
- Integrate provider sandbox credentials before production. Make payment, mandate, refund, reconciliation, and payout actions server-authorized and idempotent.
- Keep real-money features disabled or operationally manual until provider approval and end-to-end reconciliation are confirmed.
- Configure WhatsApp and telephony only for use cases that are implemented, consented to, and needed for the pilot.

### Gate 5 — Play compliance and release hardening

- Minimize Android permissions; inspect merged manifest and SDK-transitive permissions.
- Complete truthful privacy, Data safety, account deletion, content rating, app access, store listing, and billing declarations.
- Create and safely store the release upload key; produce a signed AAB and keep recovery access documented.
- Verify crashes, startup, offline/poor-network behavior, accessibility/readability, supported devices, privacy disclosures, security rules, and support flow.
- For the account's required testing track, prepare concise tester instructions and a feedback channel. Track opted-in testers and feedback; address issues before applying for production.
- Use staged rollout and monitor crash/error rates, support requests, and backend spend. Keep a rollback/recovery plan.

## How to plan each next task

When asked "what next?", return:

1. The single highest-priority next action and why it blocks production.
2. A short ordered checklist of the next few tasks, with dependencies.
3. A solo-developer estimate in focused days or weeks, distinguishing engineering work from Play's calendar waiting periods and external approvals.
4. A simple done condition and any console/provider action only the account owner can perform.
5. A clear status label: **implemented**, **locally verified**, **configured**, **deployed**, or **production verified**.

When asked to implement, pick the smallest safe slice that advances the current gate. Inspect relevant files, edit only what is needed, preserve unrelated changes, and explain any remaining account-owner steps. Do not claim Play approval or Firebase deployment without direct evidence.

## Response format for release audits

Use a compact checklist or table with:

- **Ready / blocked / unknown**
- **Evidence in the repo or console**
- **Why it matters**
- **Next action for the solo developer**
- **Effort and external wait**

End with the next one to three actions, not a long abstract backlog. Keep policy citations linked to current official sources when you browsed.
