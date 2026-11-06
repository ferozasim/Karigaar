# Handoff Report — Challenger 1 (Operational Architecture & Booking State Machine)

**Author**: `challenger_1` (Adversarial Challenger)  
**Recipient**: `3d3e2c66-2a06-4e67-9deb-5bda74c8c14f` (Parent / Orchestrator)  
**Date**: 2026-11-06  
**Verdict**: `Verdict: REQUEST_CHANGES`

---

## 1. Observation

Direct forensic inspection of `PROJECT.md` and `PHASE_0_REVIEW.md` revealed the following exact specifications and discrepancies:

1. **Atomic Coupling of Bill Submission and Completion OTP in Contract 4**:
   - In `PROJECT.md` lines 474–490:
     ```http
     POST /api/v1/bookings/KG-8842/complete-job HTTP/1.1
     Authorization: Bearer <ARTISAN_JWT>
     Content-Type: application/json

     {
       "completionOtp": "7812",
       "elapsedExecutionMinutes": 28,
       "finalTally": {
         "diagnosticLabor": 249.00,
         "spareParts": 380.00,
         "safetyInsuranceShield": 29.00,
         "gstTaxAmount": 68.22,
         "totalCustomerPayable": 629.00
       }
     }
     ```
   - Observed: Both the final invoice line items and the customer's 4-digit `completionOtp` are passed simultaneously in a single HTTP POST request.
   - Contrast with `PHASE_0_REVIEW.md` lines 780–782:
     - State 9 is defined as `WORK_COMPLETED`: *"Artisan submits final bill with spare part receipts."*
     - State 10 is defined as `CUSTOMER_VERIFICATION`: *"Customer inspects work; provides 4-digit Completion OTP."*
     - State 11 is defined as `PAYMENT_RELEASED`: *"Escrow releases funds to Artisan Guild Wallet."*

2. **The ₹99 Transit Fee vs "Pay After Inspection" Conflict**:
   - In `PHASE_0_REVIEW.md` line 793:
     *"After dispatch (>5 mins): ₹99 transit fee deducted (₹80 credited to artisan for fuel/time; ₹19 platform fee)."*
   - In `PHASE_0_REVIEW.md` line 162 (Screen 3: `active_job_live_tracking`):
     `Total Estimation: ₹848 ("Pay after full inspection")`
   - In `PHASE_0_REVIEW.md` line 396 (Screen 8: `partner_active_job_wallet`):
     `Primary completion CTA: "Verify & Collect ₹629" (task_alt icon)`
   - Observed: The customer UI permits booking without upfront payment, but the cancellation policy specifies a ₹99 deduction upon mid-route cancellation.

3. **Auto-Debit of Variable Spare Parts Under RBI AFA Regulations**:
   - In `PROJECT.md` line 501:
     `"totalDebitedFromCustomer": 629.00` (up from the base diagnostic estimate of ₹249.00 due to a ₹380 Schneider MCB).
   - Observed: No customer-side 2-Factor Authentication (AFA / OTP / UPI PIN) step or e-mandate pre-authorization is modeled for the additional ₹380.00 charge.

4. **Instant IMPS Payout with Zero Security Reserve**:
   - In `PROJECT.md` line 110:
     *"Connects with banking payout gateways (RazorpayX / Cashfree) for instant 24/7 IMPS/UPI bank withdrawals with zero partner fee."*
   - In `PHASE_0_REVIEW.md` line 407:
     *"Withdraw to Bank via UPI / IMPS (₹0 Fee) (Instant settlement)."*
   - Observed: No rolling reserve, minimum balance, or damage indemnity holdback is maintained in the Guild Wallet.

5. **Damage Guarantee Coverage Limit Discrepancy**:
   - In `PHASE_0_REVIEW.md` line 157 (Screen 3 UI review):
     *"Includes ₹10,000 damage cover, background-verified technician, & contactless OTP lock."*
   - In `PHASE_0_REVIEW.md` line 18, line 762, and `PROJECT.md` lines 153, 220:
     *"₹25,000 Guild Damage Guarantee"* and *"₹25k insurance cover"*.

6. **Radar Broadcast Expiry**:
   - In `PROJECT.md` line 97 and `PHASE_0_REVIEW.md` line 787:
     45-second circular countdown timer per artisan with auto-cascading.
   - Observed: No terminal state (`DISPATCH_UNFULFILLED` or `UNMATCHED`) exists in the 14-state machine when all available artisans in the geofence reject or timeout.

---

## 2. Logic Chain

1. **Step 1 (Start Code Deadlock)**:
   - Observation: State 8 (`IN_PROGRESS`) strictly requires the customer's 4-digit Security Start Code (`4921`).
   - Inference: If a customer refuses entry on doorstep and withholds `4921`, the booking is stuck in `ARTISAN_ARRIVED`.
   - Consequence: The artisan's app is locked, preventing new dispatches. Because no doorstep refusal state exists, the artisan must either wait indefinitely or walk away and be penalized as a false "No-Show".

2. **Step 2 (Completion OTP Hostage & Contract 4 Bug)**:
   - Observation: Contract 4 passes `completionOtp` and `finalTally` in a single request, whereas the 14-state lifecycle lists `WORK_COMPLETED` (State 9) before `CUSTOMER_VERIFICATION` (State 10).
   - Inference: The customer cannot review the bill on their device before disclosing the OTP. If the customer withholds the OTP over a bill dispute, the artisan cannot call `/complete-job`.
   - Consequence: State 9 (`WORK_COMPLETED`) is never entered, so the documented 48-hour auto-release timer (`PHASE_0_REVIEW.md` line 790) is never initialized. The artisan's funds remain trapped in escrow indefinitely.

3. **Step 3 (Financial Unenforceability of the ₹99 Transit Fee)**:
   - Observation: UI Screen 3 advertises *"Pay after full inspection"* (zero pre-funded escrow), yet the cancellation policy mandates deducting ₹99 after dispatch.
   - Inference: Under Indian banking regulations, a merchant cannot pull funds from a customer's UPI VPA or bank account without an authorized transaction or active mandate.
   - Consequence: If a customer cancels after 5 minutes, Karigaar cannot charge ₹99. Karigaar must either absorb an ₹80 fuel loss per cancellation out of its own treasury, or default on the promised artisan compensation, destroying partner supply trust.

4. **Step 4 (RBI Digital Payment Non-Compliance)**:
   - Observation: The final bill increases dynamically from ₹249 to ₹629 upon the artisan adding a ₹380 MCB, and the server debits ₹629 upon completion OTP.
   - Inference: RBI's Master Direction on Digital Payments strictly prohibits unauthorized variable debits without 2-Factor Authentication (AFA).
   - Consequence: The payment gateway will reject the debit, or the customer will dispute the charge as unauthorized, leaving the platform with unpaid parts bills.

5. **Step 5 (Wallet Drain & Property Damage Risk)**:
   - Observation: Artisans can execute instant 24/7 IMPS bank withdrawals with zero partner fee and zero minimum wallet reserve.
   - Inference: If an artisan causes severe property damage (e.g. ₹50,000 flooded floor), the artisan can drain their entire wallet balance to an external bank account in 5 seconds before a dispute is logged.
   - Consequence: Once funds reach an external bank via IMPS, they cannot be recalled. Karigaar has zero financial leverage or recourse against the artisan.

---

## 3. Caveats

1. **Regulatory Scope**: The analysis assumes domestic retail consumer payments under the Reserve Bank of India (RBI) jurisdiction and standard payment aggregators (Razorpay, Cashfree, PayU). If an enterprise corporate billing mandate is established with condominium RWAs, bulk billing terms could differ.
2. **Offline Fraud Mechanics**: Physical collusive fraud between homeowners and artisans on-site (verbal cash deals) cannot be 100% eliminated by software alone, but must be curtailed via economic retention incentives (0% commission tier and damage warranties).
3. **No Application Code**: In accordance with R3, no code files were modified or created.

---

## 4. Conclusion

**Verdict: `REQUEST_CHANGES`**

While the high-level architecture and design token specifications are remarkably thorough, the operational booking state machine and cancellation/billing workflows contain **critical deadlocks, legal/regulatory gaps, and financial enforceability vulnerabilities**. 

Before Phase 1 implementation commences, the deliverables `PROJECT.md` and `PHASE_0_REVIEW.md` must be amended with the following 6 structural fixes:
1. **Decouple Contract 4 API**: Separate into `POST /submit-bill` (moves to `WORK_COMPLETED`) and `POST /verify-completion` (customer OTP verification, moves to `PAYMENT_RELEASED`).
2. **Expand the State Machine**: Add explicit deadlock-breaker states: `DOORSTEP_ACCESS_DENIED`, `COMPLETION_PENDING_REVIEW`, and `DISPATCH_UNFULFILLED`.
3. **Resolve ₹99 Fee Enforceability**: Mandate an upfront diagnostic fee escrow hold/pre-auth for Path B, or explicitly establish a platform-funded Transit Indemnity Sinking Pool.
4. **RBI-Compliant Parts Authorization**: Mandate customer in-app approval and secondary UPI checkout for parts exceeding ₹200, governed by a pre-approved digital parts rate card.
5. **Guild Wallet Rolling Security Reserve**: Enforce a ₹1,500 locked security reserve in artisan wallets to prevent flight risk after property damage.
6. **Reconcile Damage Limits**: Align UI Screen 3 with documentation to read ₹25,000 Guild Damage Protection across all files.

---

## 5. Verification Method

To independently verify the observations, logic chain, and failure modes documented in this handoff:

1. **Verify Contract 4 Coupling**:
   - Inspect `PROJECT.md` lines 474–490 using `view_file`. Verify that `completionOtp` and `finalTally` are received together in `POST /api/v1/bookings/KG-8842/complete-job`.
2. **Verify "Pay After Inspection" vs Cancellation Fee**:
   - Inspect `PHASE_0_REVIEW.md` line 162 (`Total Estimation: ₹848 ("Pay after full inspection")`) and line 793 (`₹99 transit fee deducted`).
   - Validate that no pre-authorized payment instrument exists to capture ₹99 upon cancellation.
3. **Verify Damage Limit Discrepancy**:
   - Inspect `PHASE_0_REVIEW.md` line 157 (`Includes ₹10,000 damage cover`) vs line 18 (`₹25,000 Guild Damage Guarantee`).
4. **Verify Missing State Machine States**:
   - Inspect `PHASE_0_REVIEW.md` lines 771–785. Check whether `DISPATCH_UNFULFILLED`, `DOORSTEP_ACCESS_DENIED`, or `COMPLETION_PENDING_REVIEW` exist in the 14-state enum.

*Detailed analysis available at*: `c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\challenger_1\challenge.md`
