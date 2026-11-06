# Adversarial Challenge & Operational Stress-Testing Report

**Target Documents**: `PROJECT.md` & `PHASE_0_REVIEW.md`  
**Challenger**: `challenger_1` (Teamwork Adversarial Challenger)  
**Date**: 2026-11-06  
**Verdict**: `Verdict: REQUEST_CHANGES`

---

## 1. Executive Summary & Risk Assessment

**Overall Risk Assessment**: **CRITICAL**

While `PROJECT.md` and `PHASE_0_REVIEW.md` provide a compelling and polished architecture for Karigaar, an adversarial stress-test reveals **five foundational operational failure modes and regulatory contradictions** that will cause immediate deadlocks, financial leakages, and artisan disputes if implemented as specified:

1. **State Machine Deadlock & Contract 4 Architectural Violation**: `PROJECT.md` Contract 4 (`/api/v1/bookings/:id/complete-job`) atomically combines invoice finalization with `completionOtp` submission in a single POST request. If a customer questions the bill or withholds the OTP on-site, the artisan cannot even submit the bill or transition to `WORK_COMPLETED`. The 14-state machine has no deadlock-breaker states for doorstep access refusal, completion OTP hostage scenarios, or radar expiry.
2. **The ₹99 Cancellation Fee Enforceability Illusion**: `PHASE_0_REVIEW.md` promises a ₹99 transit cancellation fee deducted after dispatch, but the customer UI design (`service_details_custom_quote` and `active_job_live_tracking`) explicitly promises *"Pay after full inspection"* with zero upfront payment. You cannot deduct ₹99 from a customer's UPI/bank account without an active authorization or pre-funded escrow.
3. **RBI Payment Compliance & Spare Parts Billing Vulnerability**: Under RBI regulations (PSS Act and Master Direction on Digital Payments), an on-demand dynamic addition of spare parts (e.g. +₹380 for an MCB, taking a ₹249 booking to ₹629) **cannot be silently debited from a customer's bank account or UPI** without 2-Factor Authentication (OTP / UPI PIN). Furthermore, there are zero catalog price caps, enabling collusive or inflated on-site billing.
4. **Instant Wallet Drain & Catastrophic Damage Flight Risk**: The platform promotes 24/7 instant zero-fee IMPS withdrawals to artisan bank accounts. In the event of catastrophic property damage (e.g. sheared concealed plumbing pipe causing ₹50,000 in flooring damage), a fleeing artisan can drain their entire Guild Wallet in 3 seconds before Super Admin arbitration can freeze funds, leaving the platform with 100% of the liability.
5. **Specification Discrepancy on Damage Guarantee**: Screen 3 UI specifies *"Includes ₹10,000 damage cover"* while documentation throughout `PROJECT.md` and `PHASE_0_REVIEW.md` promises *"₹25,000 Guild Damage Guarantee"*, creating immediate legal exposure and consumer dispute vulnerability.

---

## 2. In-Depth Adversarial Challenges

---

### Challenge 1: The "Doorstep Access Refusal" Deadlock (Start Code `4921` Withholding)
- **Severity**: **CRITICAL**
- **Assumption Challenged**: The state machine assumes that once an artisan arrives within the 200m geofence (`ARTISAN_ARRIVED`), the resident will cooperatively disclose the 4-digit Security Start Code (`4921`) to transition to `IN_PROGRESS` (`PROJECT.md` line 105, 431; `PHASE_0_REVIEW.md` line 778–779).
- **Attack Scenario**:
  - An electrician rides 4.2 km through Gurugram evening traffic, burning fuel and 25 minutes, and reaches the customer's apartment door.
  - The resident refuses to open the door or refuses to share Start Code `4921`, stating: *"My brother already tightened the fuse wire"*, *"You took 5 minutes longer than the initial estimate"*, or disputes the diagnostic visit fee before allowing entry.
  - The customer refuses to tap *"Cancel Booking"* in the app to avoid paying the doorstep visit fee (`PHASE_0_REVIEW.md` line 794: *"At doorstep: Full visit fee charged (85% paid to artisan)"*).
  - The artisan cannot enter `4921` without customer cooperation.
- **Blast Radius**:
  - The booking is permanently frozen in `ARTISAN_ARRIVED`.
  - The partner app remains locked in an active job state, blocking the artisan from receiving new radar broadcasts.
  - If the artisan walks away, the system's cron timer eventually marks them as a "No-Show", erroneously triggering a 24-hour suspension and deducting penalties from the innocent artisan!
  - Conversely, if an unverified "Customer Refused Entry" button is provided to the artisan, dishonest artisans will exploit it: driving within 200m of a condominium gate, tapping "Arrived" -> "Refused Entry", and pocketing the 85% visit fee without ever entering the premises.
- **Empirical Gap in Specs**: Neither `PROJECT.md` nor `PHASE_0_REVIEW.md` defines an exception transition out of `ARTISAN_ARRIVED` when the customer withholds the Start Code.
- **Required Mitigation & Founder Protocol**:
  1. Add an explicit state: `DOORSTEP_ACCESS_DENIED`.
  2. Implement an automated **Two-Sided Doorstep Standby Protocol**:
     - If Start Code `4921` is not validated within 5 minutes of geofence arrival, an automated 7-minute countdown begins on both devices.
     - An automated high-priority WhatsApp push and IVR call are dispatched to the resident: *"Your Karigaar partner Rajesh has arrived. Please share Start Code 4921 or tap Cancel. If no action is taken within 7 minutes, the booking will cancel and the standard visit fee will be billed."*
     - If the timer expires without customer validation, the booking automatically transitions to `DOORSTEP_ACCESS_DENIED`.
     - Anti-fraud requirement: The partner app must mandate a geotagged, timestamped photo of the apartment door/building intercom before `DOORSTEP_ACCESS_DENIED` can be submitted. Full visit fee is billed; 85% is credited to the artisan.

---

### Challenge 2: The "Post-Execution Hostage" Deadlock & Contract 4 API Flaw (Completion OTP Withholding)
- **Severity**: **CRITICAL**
- **Assumption Challenged**: Service completion and payment release proceed sequentially through States 9, 10, and 11 (`WORK_COMPLETED` -> `CUSTOMER_VERIFICATION` -> `PAYMENT_RELEASED`), with a 48-hour auto-release fail-safe (`PHASE_0_REVIEW.md` lines 780–782, 790).
- **Attack Scenario & API Violation**:
  - **The Architectural API Defect**: In `PROJECT.md` Contract 4 (lines 474–490), the endpoint to finish a job is:
    ```http
    POST /api/v1/bookings/KG-8842/complete-job HTTP/1.1
    Authorization: Bearer <ARTISAN_JWT>
    {
      "completionOtp": "7812",
      "elapsedExecutionMinutes": 28,
      "finalTally": { ... }
    }
    ```
    This endpoint **atomically couples invoice submission and Completion OTP verification into a single call**.
  - **The Failure Mode**:
    1. The customer CANNOT inspect the final itemized bill on their own phone prior to sharing the OTP, because the bill is only submitted to the server *at the exact moment the OTP is sent*!
    2. If the customer is dissatisfied, steps out of the house, or maliciously withholds the Completion OTP (e.g., demanding a ₹200 cash discount on parts), the artisan CANNOT execute `/complete-job`.
    3. Because `/complete-job` fails, the booking NEVER reaches `WORK_COMPLETED` (State 9) or `CUSTOMER_VERIFICATION` (State 10).
    4. The documented 48-hour auto-release timer (`PHASE_0_REVIEW.md` line 790) is specified as *"48 hours post-completion if uncontested"*. Because the job never reached `WORK_COMPLETED`, **the auto-release timer is never initialized**!
- **Blast Radius**:
  - The artisan's labor payout and out-of-pocket material expenses are frozen in limbo indefinitely.
  - Causes physical altercations at the customer's residence as the artisan refuses to leave without payment.
- **Required Mitigation & Founder Protocol**:
  1. **Decouple the Backend API into Two Distinct Calls**:
     - `POST /api/v1/bookings/:id/submit-bill`: Artisan submits final stopwatch duration, itemized labor, spare parts, and receipt photos. Moves state from `IN_PROGRESS` -> `WORK_COMPLETED`.
     - System triggers instant WhatsApp / In-App bill notification to customer with itemized breakdown.
     - `POST /api/v1/bookings/:id/verify-completion`: Customer enters Completion OTP on their own app (or artisan enters OTP verbally provided by customer). Moves state from `CUSTOMER_VERIFICATION` -> `PAYMENT_RELEASED`.
  2. **Unresponsive Customer Escrow Auto-Release Engine**:
     - If the customer does not verify or raise a dispute within 30 minutes of `WORK_COMPLETED`, the booking transitions to `COMPLETION_PENDING_REVIEW`.
     - A 24-hour contestation window is initiated. If no formal dispute is logged by the customer with photo evidence within 24 hours, the double-entry escrow engine auto-releases 100% of the funds to the artisan's Guild Wallet.

---

### Challenge 3: Geofence Failure & Mid-Route GPS Telemetry Blackout
- **Severity**: **HIGH**
- **Assumption Challenged**: Real-time GPS coordinate streams over WebSockets/MQTT reliably update customer polylines and auto-trigger arrivals at a 200m geofence (`PROJECT.md` line 100–102; `PHASE_0_REVIEW.md` line 778).
- **Attack Scenario**:
  - **Scenario A (Gurugram Basement / High-Rise Dead-Zones)**: In luxury complexes like DLF The Aralias, The Camellias, or Sector 48 towers, visitors must park in subterranean B2/B3 levels or pass through thick reinforced-concrete elevator lobbies. GPS signal drops completely (0 satellites visible) or drifts by 400m+. The server-side 200m geofence rejects the artisan's `ARTISAN_ARRIVED` tap.
  - **Scenario B (OS Battery Management / Process Termination)**: Budget Android phones used by most Indian tradespeople (Xiaomi MIUI, Realme UI, Vivo Funtouch) aggressively kill background and foreground telemetry services to preserve battery when the screen turns off during riding. The customer sees the motorcycle marker freeze on Cyber Hub for 15 minutes while the artisan is actually navigating via standalone Google Maps.
  - **Scenario C (Artisan No-Show Exploitation)**: An artisan accepts a dispatch, gets an offline cash call, turns off mobile data, and ignores the app.
- **Blast Radius**:
  - Customer suffers severe anxiety, assumes the artisan is lost, and cancels prematurely.
  - Honest artisans arriving in GPS dead-zones are falsely flagged for SLA breach or prevented from starting work.
- **Empirical Gap in Specs**: No telemetry heartbeat timeout threshold is specified in `PROJECT.md` or `PHASE_0_REVIEW.md`.
- **Required Mitigation & Founder Protocol**:
  1. **Telemetry Heartbeat Watchdog**:
     - If the partner app fails to stream coordinates for **180 seconds** during `ARTISAN_DISPATCHED`, flag status as `TELEMETRY_DEGRADED` on the customer app: *"Artisan is en route (GPS updating periodically via cell tower)"*.
     - If offline for **360 seconds**, send an automated high-priority SMS ping to wake up the partner service.
  2. **Cryptographic Proximity Override (Geofence Bypass)**:
     - If GPS is inaccurate (>200m) due to indoor attenuation, permit the artisan to bypass the geofence check by **entering the customer's Start Code `4921`**.
     - Because only the homeowner has the 4-digit code displayed on their screen, physical knowledge of `4921` is indisputable mathematical proof of co-location, completely superseding imperfect satellite trilateration.
  3. **Dynamic SLA Calculation**:
     - The 15-minute grace period must dynamically re-anchor to real-time traffic ETAs, but be capped at a hard maximum threshold (+25 minutes from original ETA). If breached without partner communication, customer is offered 1-tap cancellation with 100% refund and a ₹100 platform apology credit.

---

### Challenge 4: Fraudulent Spare Parts Invoicing & RBI Digital Payment Compliance Violation
- **Severity**: **CRITICAL**
- **Assumption Challenged**: Dynamic on-site addition of spare parts (e.g. Schneider 32A MCB for +₹380, `PROJECT.md` lines 109, 458–472) is seamlessly debited from the customer and credited to the artisan.
- **Attack Scenario & Regulatory Conflict**:
  - **Vector A (Collusive Bill Inflation)**: An artisan purchases an unbranded, low-grade ₹80 circuit breaker from a local market, obtains an inflated handwritten receipt for ₹450 from a neighborhood hardware shop, uploads a blurry receipt photo to `partner_active_job_wallet`, and bills the customer ₹450. The customer has no way of verifying fair market pricing.
  - **Vector B (RBI Mandatory Additional Factor of Authentication [AFA] Breach)**:
    - In `PROJECT.md` line 488 and line 501, the final bill increases from the initial estimated diagnostic fee (₹249) to **₹629.00**, and the ledger executes:
      `"totalDebitedFromCustomer": 629.00`.
    - **CRITICAL LEGAL CONFLICT**: Under the Reserve Bank of India (RBI) Regulations for Electronic Payment Transactions, **a merchant cannot pull an arbitrary, variable debit (e.g. ₹629) from a customer's UPI, debit card, or credit card without an explicit 2-Factor Authentication (OTP or UPI PIN) prompt**, unless an e-mandate with a pre-registered maximum cap was explicitly approved during checkout.
    - If Karigaar attempts to auto-debit the difference without customer authorization, the payment gateway transaction will hard-fail with `RBI_AFA_REQUIRED` or `PAYMENT_UNAUTHORIZED`.
  - **Vector C (Customer Rejection of Installed Parts)**: The artisan installs the breaker inside the distribution board. When presented with the ₹629 bill, the resident states: *"I didn't authorize ₹380 for this MCB. I only agreed to the ₹249 visit fee. I will not pay for the part."* The customer refuses to authenticate the additional payment.
- **Blast Radius**:
  - The platform is exposed to severe financial leakage. If Karigaar covers the artisan's ₹380 part reimbursement out of pocket, unit economics collapse. If Karigaar refuses to pay the artisan, the artisan guild strikes and off-platform disintermediation spikes.
- **Required Mitigation & Founder Protocol**:
  1. **Pre-Approved Digital Guild Parts Catalog**:
     - Codify a standardized digital catalog for the top 40 high-frequency replacement parts (MCBs, angle valves, cistern ball cocks, 16A modular sockets, mixer cartridges).
     - Fix transparent maximum benchmark prices (MRP + 10% procurement/handling fee).
  2. **Mandatory In-App Customer Authorization Gate**:
     - Any spare part added on-site must trigger a real-time push alert and WhatsApp approval link to the customer:
       *"Rajesh has requested to add: Schneider 32A MCB (₹380.00). Tap to approve before installation."*
  3. **Two-Stage Escrow / UPI Collect Flow**:
     - When parts exceed ₹200, the customer app prompts an immediate UPI Collect request (Google Pay, PhonePe, Paytm) or card pre-auth to top up the escrow balance *before* the artisan completes the job.

---

### Challenge 5: Radar Broadcast Expiry with 0 Accepts (Supply Deficit Deadlock)
- **Severity**: **HIGH**
- **Assumption Challenged**: The 45-second circular countdown timer cascades cleanly to the next nearest artisan until claimed (`PROJECT.md` line 97; `PHASE_0_REVIEW.md` line 787).
- **Attack Scenario**:
  - During a severe thunderstorm emergency in Gurugram (DLF Phase 1–5), 25 households experience sudden electrical trips simultaneously.
  - All 12 verified electricians active in the 3 km radius are either already engaged on active jobs or pass on the 45-second dispatch card.
  - The 45-second countdown timer expires across all available artisans in the geofence.
- **Blast Radius**:
  - The 14-state machine defined in `PHASE_0_REVIEW.md` (lines 771–785) **contains NO state for broadcast exhaustion or supply unfulfillment** (`UNMATCHED`, `DISPATCH_EXPIRED`, or `RETRYING`).
  - The customer is left watching a perpetual skeleton loading screen (`skeleton_loading_radar_sync`) while their funds or booking request remain trapped.
  - Customer churns to unvetted local contractors or competitors (Urban Company).
- **Required Mitigation & Founder Protocol**:
  1. Add explicit state: `DISPATCH_UNFULFILLED`.
  2. Define an automated **3-Tier Cascade & Expansion Engine**:
     - *Tier 1 (0 to 45s)*: Broadcast to nearest 3 qualified Tier 2/3 artisans within 3 km.
     - *Tier 2 (45s to 90s)*: If unaccepted, expand radius to 6 km and attach a platform-funded ₹50 quick-dispatch incentive.
     - *Tier 3 (90s to 135s)*: If still unaccepted, push emergency blast to Tier 1 standby partners.
  3. **Graceful Exhaustion Fallback (Founder Options)**:
     If 0 accepts after 135 seconds, immediately transition booking to `DISPATCH_UNFULFILLED` and offer the customer three clear actions:
     - **Option 1 (Surge Incentive)**: Add a self-funded ₹100–₹150 emergency surge bonus to re-broadcast.
     - **Option 2 (Scheduled Morning Slot)**: Convert request to a guaranteed arrival slot next morning with a ₹50 discount voucher.
     - **Option 3 (Switch to Path A Direct Directory)**: Instantly display the top 3 verified master profiles with direct call buttons (`tel:`) and immediately release any escrow hold.

---

### Challenge 6: Enforceability of the ₹99 Transit Cancellation Fee
- **Severity**: **CRITICAL**
- **Assumption Challenged**: `PHASE_0_REVIEW.md` line 793 states: *"After dispatch (>5 mins): ₹99 transit fee deducted (₹80 credited to artisan for fuel/time; ₹19 platform fee)."*
- **Attack Scenario & Financial Loophole**:
  - **The Contradiction**: Screen 3 (`active_job_live_tracking`, `PHASE_0_REVIEW.md` line 162) explicitly specifies:
    `Total Estimation: ₹848 ("Pay after full inspection")`.
    Furthermore, Screen 8 (`partner_active_job_wallet`, line 396) specifies the completion CTA as `"Verify & Collect ₹629"`.
  - **The Reality**: If customers are allowed to book on Path B under the promise of "Pay after inspection" with zero upfront payment, **the platform holds ₹0 at the time of dispatch**.
  - A customer books an emergency plumber at 02:00 PM. An artisan is dispatched at 02:02 PM and rides 3 km towards DLF Phase 4. At 02:10 PM (>5 mins post-dispatch), the customer taps *"Cancel Booking"*.
  - **How does the platform collect ₹99?**
    The platform cannot execute an unauthorized debit on the customer's UPI ID or debit card!
- **Blast Radius**:
  - The platform has contractually promised the artisan ₹80 for fuel and transit compensation.
  - If the platform cannot charge the customer, Karigaar must pay ₹80 out of its own operational treasury. At scale, uncollected cancellations will bleed hundreds of thousands of rupees monthly.
  - If Karigaar fails to pay the artisan ₹80, the artisan suffers fuel loss and loses faith in the platform guarantee.
- **Required Mitigation & Founder Decision Choices**:
  The founder must choose between three distinct business models:
  - **Model A (Mandatory Upfront Authorization / Escrow Hold - Recommended)**:
    Eliminate the ambiguous "Pay after full inspection" for Path B emergency dispatch. Require an upfront UPI Pre-Authorization or card hold for the base diagnostic fee (₹199 or ₹249) before triggering the Radar. If cancelled after 5 minutes, ₹99 is captured, remainder is refunded in 60 seconds.
  - **Model B (Post-Facto Account Arrears)**:
    Retain zero-friction booking, but if cancelled after 5 minutes, log a ₹99 outstanding debit balance on the user's phone profile. The user is locked from creating new bookings until the balance is cleared. Karigaar underwrites the ₹80 artisan payout up to 1 cancellation per customer as CAC.
  - **Model C (Transit Guarantee Sinking Fund)**:
    Dedicate ₹8 of the ₹29 Platform Safety & Insurance Fee into a collective "Artisan Transit Indemnity Pool" that automatically disburses the ₹80 fuel compensation when customer transit cancellation fees cannot be collected.

---

### Challenge 7: On-Site Property Damage Claims & Wallet Flight Risk
- **Severity**: **CRITICAL**
- **Assumption Challenged**: The ₹25,000 Guild Damage Guarantee and ₹29 Safety Fee adequately protect the ecosystem, and State 13 (`DISPUTED`) safely contains damage claims (`PHASE_0_REVIEW.md` lines 18, 762, 784, 807).
- **Attack Scenario**:
  - A plumber attempts to replace an angle cock in an apartment in DLF Phase 5. The plumber uses excessive torque, cracking the internal concealed pipe elbow inside the wall.
  - High-pressure water floods the master bedroom, damaging hardwood flooring, expensive rugs, and false ceilings, resulting in an estimated ₹55,000 damage claim.
  - **The Wallet Flight Exploit**:
    The artisan recognizes the catastrophic failure. While the homeowner is busy turning off the main building riser valve, the artisan opens `partner_active_job_wallet`, taps *"Withdraw to Bank via UPI / IMPS (₹0 Fee)"*, and instantly withdraws their entire cleared balance (`₹4,620`) to their external HDFC bank account in under 5 seconds (`PROJECT.md` line 110, `PHASE_0_REVIEW.md` line 407).
    The artisan then leaves the premises and blocks communications.
  - **The Documentation Discrepancy**:
    Screen 3 UI design (`PHASE_0_REVIEW.md` line 157) displays:
    `"Includes ₹10,000 damage cover, background-verified technician, & contactless OTP lock."`
    However, executive text in `PHASE_0_REVIEW.md` lines 18, 762 and `PROJECT.md` lines 153, 220 promises **`₹25,000 Guild Damage Protection`**!
- **Blast Radius**:
  - The customer demands ₹25,000 (or ₹55,000) compensation. The resident's RWA bans Karigaar from the entire condominium complex.
  - Karigaar has zero financial leverage over the artisan because the artisan's wallet balance is ₹0 and bank withdrawals cannot be reversed via IMPS.
- **Required Mitigation & Founder Protocol**:
  1. **Mandatory Pre-Work Digital Condition Audit**:
     Before entering Start Code `4921`, the partner app must require 2 mandatory photos:
     - Photo 1: Status of main water shutoff valve / electrical isolator.
     - Photo 2: Close-up of existing fixture/pipe/wiring condition.
     This establishes an unalterable timestamped baseline of pre-existing wear vs artisan negligence.
  2. **Artisan Rolling Security Reserve (Wallet Holdback)**:
     - End the practice of allowing 100% immediate withdrawal of all wallet earnings.
     - Enforce a **Rolling Security Reserve**: Maintain a locked balance of **₹1,500** (or 20% of the last 7 days' earnings) in the Guild Wallet that cannot be withdrawn immediately via IMPS. Cleared funds *above* the reserve remain eligible for 24/7 instant withdrawal.
  3. **Reconcile Damage Policy Limits & Underwriting Protocol**:
     - Formally align UI Screen 3 with the documentation: update the UI banner to read **₹25,000 Guild Damage Protection**.
     - Specify the third-party general liability insurance underwriter (e.g., Digit / ICICI Lombard / Acko) funded by the ₹29 Customer Safety Fee.
     - Define an explicit 4-hour physical surveyor SLA for Gurugram pilot claims exceeding ₹5,000.

---

### Challenge 8: Path A vs Path B State Machine Conflation
- **Severity**: **HIGH**
- **Assumption Challenged**: The 14-state lifecycle (`PHASE_0_REVIEW.md` lines 771–785) is described as managing transitions across *both* Path A and Path B.
- **Attack Scenario**:
  - In Path B (Instant Emergency Booking), States 2, 3, and 4 (`QUOTE_REQUESTED`, `QUOTES_RECEIVED`, `QUOTE_ACCEPTED`) NEVER OCCUR! The customer selects a task and directly triggers dispatch.
  - In Path A (Direct Contact / Bidding), the customer browses master profiles and calls via `tel:` or `wa.me`. The platform backend does not observe the initial negotiation unless formal bidding is initiated.
  - Forcing Path A and Path B into a single flat linear enum causes invalid state transitions, null-pointer database exceptions, and unhandled branch logic in backend services.
- **Blast Radius**: Severe bugs in `booking_escrow_service` state machine triggers, broken analytics, and corrupted lifecycle tracking.
- **Required Mitigation**:
  Split the state machine into distinct, well-defined lifecycles or explicit sub-states:
  - **Path B (Instant / Managed Dispatch)**:
    `DRAFT` -> `DISPATCH_SEARCHING` -> `ARTISAN_DISPATCHED` -> `ARTISAN_ARRIVED` -> `IN_PROGRESS` -> `WORK_COMPLETED` -> `CUSTOMER_VERIFICATION` -> `PAYMENT_RELEASED` -> `CLOSED`.
    (With branches: `DISPATCH_UNFULFILLED`, `DOORSTEP_ACCESS_DENIED`, `CANCELLED`, `DISPUTED`).
  - **Path A (Direct / Custom Project Bidding)**:
    `PROJECT_DRAFT` -> `QUOTES_REQUESTED` -> `QUOTES_RECEIVED` -> `QUOTE_ACCEPTED` -> `DEPOSIT_ESCROWED` -> `MILESTONE_ACTIVE` -> `MILESTONE_COMPLETED` -> `PAYMENT_RELEASED` -> `CLOSED`.

---

## 3. Empirical Stress-Test Results Matrix

| # | Stress Scenario | Input Parameters | Documented / Expected Behavior | Actual Spec Vulnerability / Failure Mode | Test Result |
|:---|:---|:---|:---|:---|:---:|
| **ST-01** | Artisan phone enters basement dead-zone at Flat 402 | GPS accuracy >500m; WebSocket disconnects for 5 mins | Auto-detect arrival within 200m geofence | Arrival blocked by geofence; artisan cannot transition to `ARTISAN_ARRIVED` or enter Start Code `4921` | **FAIL** |
| **ST-02** | Customer refuses to share Start Code `4921` on doorstep | Artisan at door; customer withholds PIN | State advances to `IN_PROGRESS` upon PIN entry | Infinite deadlock in `ARTISAN_ARRIVED`; no exit state or doorstep standby protocol | **FAIL** |
| **ST-03** | Customer withholds Completion OTP over bill dispute | Work done; customer refuses OTP | Escrow auto-releases after 48h uncontested post-completion | Contract 4 cannot submit final bill without OTP; job never reaches `WORK_COMPLETED`; 48h timer never starts | **FAIL** |
| **ST-04** | Artisan bills extra ₹380 for MCB on-site | Base ₹249 + ₹380 part = ₹629 total | System debits ₹629 from customer escrow | Fails under RBI AFA regulations; cannot pull variable debit without customer 2FA/UPI authorization | **FAIL** |
| **ST-05** | Thunderstorm surge: 0 of 8 artisans accept 45s radar | 45s countdown expires across all cascaded artisans | Auto-cascades to next qualified artisan | Supply exhausted; no `DISPATCH_UNFULFILLED` state; customer trapped on infinite shimmer screen | **FAIL** |
| **ST-06** | Customer cancels en route 8 mins after dispatch | Customer taps Cancel; "Pay after inspection" | ₹99 deducted from customer (₹80 to artisan, ₹19 to platform) | Platform holds ₹0 upfront; cannot auto-debit customer; platform must absorb ₹80 loss or default on artisan | **FAIL** |
| **ST-07** | Sheared concealed pipe causes ₹50,000 water damage | Plumber causes flood; taps instant withdrawal | Dispute frozen in Super Admin arbitration | Plumber drains entire Guild Wallet via IMPS in 5s; zero rolling reserve; platform left with 100% loss | **FAIL** |
| **ST-08** | Customer checks damage cover terms on Screen 3 | Screen 3 UI vs Section 1/5 documentation | Transparent, verified ₹25,000 warranty | Screen 3 displays "₹10,000 damage cover" while docs promise "₹25,000", creating legal exposure | **FAIL** |

---

## 4. Unchallenged Areas

The following domains were evaluated and found structurally robust, requiring no adversarial intervention:
1. **Design System Tokens & Tactile Modernism**: Slate (`#0F172A`), Amber (`#F59E0B`), and Emerald (`#10B981`) palettes, 390px baseline, and typographic scale are cohesive and faithfully documented.
2. **Dual-Application Topology Decision (Option 3B)**: The architectural decision to separate Customer and Partner Flutter apps in a shared monorepo avoids Apple App Store background location rejections and simplifies vocational UX.
3. **Pilot Corridor Clustering (Gurugram Option 1A)**: Bounding the pilot to DLF Phase 1–5, Cyber City, and Sector 42–48 corridor provides optimal supply density and willingness to pay.
4. **Instant WhatsApp 1-Tap Auth & DLT Fallback**: The 42-second countdown timer with secondary DLT SMS fallback provides resilient authentication across Indian telcos.

---

## 5. Explicit Actionable Requirements for Phase 0 Amendment

To clear this challenge and enable Phase 1 engineering, the following modifications must be incorporated into `PROJECT.md` and `PHASE_0_REVIEW.md`:

1. **Decouple Contract 4 API**: Separate `/complete-job` into two endpoints: `POST /submit-bill` (artisan submit) and `POST /verify-completion` (customer OTP release), enabling customer bill review and unblocking the 24h/48h auto-release timer.
2. **Expand the State Machine to Include Exception & Deadlock States**:
   - Add `DOORSTEP_ACCESS_DENIED`, `COMPLETION_PENDING_REVIEW`, and `DISPATCH_UNFULFILLED`.
   - Explicitly separate Path A (Bidding) from Path B (Instant Dispatch) lifecycle enums.
3. **Resolve the ₹99 Transit Fee Financial Mechanism**:
   - Add an explicit founder decision to Decision 5: Require an upfront diagnostic deposit/pre-auth for Path B, or establish an Artisan Transit Indemnity Pool funded from the ₹29 safety fee.
4. **Codify RBI-Compliant Spare Parts Billing & Price Caps**:
   - Mandate customer in-app approval for any spare part line item >₹200 with secondary UPI Intent checkout.
   - Enforce a standardized rate card catalog for top 40 consumable parts.
5. **Mitigate Wallet Drain Flight Risk**:
   - Mandate a **₹1,500 Rolling Security Reserve** in the Guild Wallet, allowing 24/7 IMPS withdrawals only for balances exceeding the reserve.
   - Mandate 2 pre-work photos before Start Code entry to establish pre-existing baseline.
6. **Reconcile Damage Cover Limits**:
   - Update UI Screen 3 reference in `PHASE_0_REVIEW.md` to consistently state **₹25,000 Guild Damage Protection** across all assets.

---

## 6. Official Verdict

`Verdict: REQUEST_CHANGES`

*Assessment: The documented architecture is exceptional in vision and frontend fidelity, but contains critical operational, legal, and financial failure modes in its state transitions, payment enforceability, and dispute protocols. Incorporating the 6 actionable remedies above will make Karigaar bulletproof for real-world deployment in Gurugram.*
