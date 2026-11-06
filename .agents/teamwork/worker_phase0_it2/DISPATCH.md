# Worker Phase 0 - Iteration 2 Remediation
Task assignment for updating PROJECT.md and PHASE_0_REVIEW.md with the specific operational, state-machine, and financial remedies requested by Challenger 1 and Challenger 2.

## 2026-11-06T13:00:23Z
You are teamwork_worker (worker_phase0_it2). Your working directory is c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\worker_phase0_it2.
Read c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\ORIGINAL_REQUEST.md.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

File write ownership:
You own exclusively:
- c:\Users\asimf\OneDrive\Desktop\Karigaar_app\PROJECT.md
- c:\Users\asimf\OneDrive\Desktop\Karigaar_app\PHASE_0_REVIEW.md
- All metadata files inside c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\worker_phase0_it2\

Task:
Remediate and update `PROJECT.md` and `PHASE_0_REVIEW.md` to resolve all 11 adversarial challenges raised by Challenger 1 and Challenger 2:

1. API Decoupling: In `PROJECT.md` § Interface Contracts (Contract 4) and `PHASE_0_REVIEW.md`:
   - Split `/complete-job` into two endpoints:
     - `POST /api/v1/bookings/:id/submit-invoice` (Artisan uploads itemized bill, parts breakdown, receipt photos; transitions state to `INVOICE_SUBMITTED`).
     - `POST /api/v1/bookings/:id/verify-completion` (Customer verifies work on their screen, inputs Completion OTP to release escrow).
   - Document that if customer disputes on-site, the bill is already recorded, preventing state machine deadlock.
2. Upfront Escrow Pre-Authorization / UPI Mandate:
   - In Decision 5 and Booking flow, specify upfront pre-authorization / UPI mandate during booking confirmation so the ₹99 transit cancellation fee is automatically collectible if customer cancels after dispatch.
3. RBI 2FA Compliance for Scope Expansion:
   - In Decision 5, specify that on-site spare parts or scope additions require explicit in-app customer approval or OTP before adding to the bill, ensuring RBI 2FA compliance.
4. Instant Wallet Drain Protection:
   - In Decision 5/6, Guild Wallet architecture, and Contract 4, add a ₹2,000 rolling security reserve or 24h settlement hold on newly completed jobs to protect against post-service property damage claims.
5. Harmonize Damage Insurance Coverage:
   - Reconcile Screen 3 UI (₹10,000) with documentation: define the two-tier structure (Base ₹10,000 property damage guarantee included in ₹29 safety fee; ₹25,000 comprehensive cover for Master Guildsman tier or premium add-on).
6. Missing State Machine Terminal / Exception States:
   - Add `DISPATCH_UNFULFILLED` (radar broadcast expires after 45s without acceptance, triggering automatic re-dispatch or fallback) and `DOORSTEP_ACCESS_DENIED` (customer unreachable/denies entry for >15 mins after artisan arrival, releasing ₹99 transit fee to artisan and closing job).
   - Clearly delineate Path A (Direct Contact) lifecycle from Path B (Structured Booking) state machine.
7. Path A Monetization & Cannibalization Defense:
   - In Decision 4, formulate explicit founder options for monetizing Path A: Pay-per-lead unlock (₹49–₹99 per lead), Guild Directory Monthly Pass (₹499/mo), or Virtual Click-to-Call paywall, analyzing the cannibalization trade-offs.
8. Sustainable Master Guildsman Tier:
   - In Decision 6 and `PROJECT.md`, replace the negative-margin 0% commission tier with a sustainable 5% floor or ₹999/month "Guild Elite" subscription, ensuring positive unit economics across payment gateway fees, IMPS, and telephony.
9. Eliminate Raw Phone Numbers from API Contracts:
   - In Contract 2 and screen specs, remove raw unmasked `wa.me` numbers. Enforce virtual telephony bridge endpoints (`/api/v1/telephony/bridge-call`) and in-app secure chat.
10. Pass-Through Parts Gateway Fee Handling:
    - Add a 2% payment gateway convenience surcharge on customer payments for pass-through parts to protect the ₹29 safety fee.
11. Warranty Reserve & Deductibles:
    - Specify a ₹250 customer deductible on damage claims to deter frivolous claims, and mandate reserving 30% of platform take-rate for the Warranty & Rework Underwriting Reserve.

CRITICAL CONSTRAINT: Do NOT write or create any application source code files (.dart, .js, .ts, .py, etc.). Phase 0 is strictly documentation.

Write your changes to `PROJECT.md` and `PHASE_0_REVIEW.md`, create `handoff.md` in your working directory, and message the caller when done.
