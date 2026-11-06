# Dual Engagement Paths & End-to-End User Journey Analysis

## Executive Summary

Karigaar is an on-demand, hyperlocal home services platform designed for the Indian trade ecosystem (carpenters, electricians, plumbers, painters, appliance mechanics, masons). The platform's product architecture addresses a fundamental tension in the Indian service economy: **the conflict between informal direct hiring (offline convenience, personal trust, cash/direct UPI) and structured platform guarantees (safety, vetted KYC, escrow-backed warranty, verified pricing).**

Rather than forcing all customer-artisan interactions into a single rigid funnel, the Karigaar UI and system architecture establish **Dual Engagement Paths**:
1. **Path A — Direct Contact (Open Directory / Lead-Based Model):** Customer-driven discovery of master craftsmen with transparent credentials, visit fees, portfolio galleries, and direct communication channels (phone, WhatsApp), facilitating offline scoping or direct hiring while offering platform incentives to formalize bookings.
2. **Path B — Structured Booking (Managed Marketplace / Escrow-Protected Model):** An end-to-end, guaranteed, high-trust workflow incorporating visual/voice scoping, algorithm-driven Job Radar matching, live GPS tracking, dual-stage security OTP verification (arrival & completion), in-job dynamic bill adjustment (material + labor), and instant escrow-to-wallet settlement via IMPS.

Across all 12 reference UI screens and the `karigaar_artisan_trust` design system, these two paths share a unified brand foundation ("Master Guildsman Meets Modern Concierge"), an integrated WhatsApp-first messaging spine, and a centralized Super Admin governance apparatus.

---

## 1. Architectural Deep-Dive: Dual Engagement Paths

```
                       ┌────────────────────────────────────────┐
                       │          Customer Entry Point          │
                       │    (home_discovery / login_auth)       │
                       └───────────────────┬────────────────────┘
                                           │
                  ┌────────────────────────┴────────────────────────┐
                  ▼                                                 ▼
      ┌───────────────────────┐                         ┌───────────────────────┐
      │        PATH A         │                         │        PATH B         │
      │    Direct Contact     │                         │  Structured Booking   │
      │    (Open Directory)   │                         │  (Managed Escrow)     │
      └───────────┬───────────┘                         └───────────┬───────────┘
                  │                                                 │
      • Browse Top Masters Nearby                       • Select Category & Issue
      • Inspect Guild Badges & Portfolio                • Upload Photo & 15s Voice Memo
      • Check Inspection Fee (e.g. ₹299)                • Select Guaranteed Arrival Slot
      • View Client Scorecards                          • Review Upfront Estimate Breakdown
                  │                                                 │
                  ▼                                                 ▼
      ┌───────────────────────┐                         ┌───────────────────────┐
      │ Direct Channel Touch  │                         │   Job Radar Broadcast │
      │ (Phone / WhatsApp)    │                         │   (45s Artisan Match) │
      └───────────┬───────────┘                         └───────────┬───────────┘
                  │                                                 │
                  ▼                                                 ▼
      ┌───────────────────────┐                         ┌───────────────────────┐
      │  Offline Scoping &    │ ◄── [Optional Escrow] ──┤ En-Route GPS Tracking │
      │  Direct Negotiation   │     [Formalization]     │ & Start OTP (4921)    │
      └───────────┬───────────┘                         └───────────┬───────────┘
                  │                                                 │
                  ▼                                                 ▼
      ┌───────────────────────┐                         ┌───────────────────────┐
      │ P2P Direct Settlement │                         │ In-Job Dynamic Bill   │
      │ (No Platform Cover)   │                         │ & Completion OTP Sign │
      └───────────────────────┘                         └───────────┬───────────┘
                                                                    │
                                                                    ▼
                                                        ┌───────────────────────┐
                                                        │ Instant IMPS Payout & │
                                                        │ Verified Review / CSAT│
                                                        └───────────────────────┘
```

---

### 1.1 Path A: Direct Contact (Open Directory / Lead-Based Model)

#### Objective & Market Justification
In Indian metropolitan and Tier-1/2 residential hubs, many homeowners already have informal mechanisms to find tradespeople (RWA security guards, local hardware store references, neighborhood directories). However, these informal referrals lack safety vetting, verified skill credentials, and transparent rate cards. 

Path A satisfies the customer who wants **autonomy and direct human negotiation** without having to commit upfront to a managed marketplace dispatch.

#### User Journey Stages in Path A
1. **Discovery & Exploration (`home_discovery`):**
   - The user opens the home screen and explores the **"Top Masters in Sector 4"** section.
   - Cards display master craftsmen like *Rajesh Sharma (Master Carpenter, 8 yrs exp, 1.4 km away)* and *Tariq Anwar (Certified Electrician, 12 yrs exp, 2.1 km away)*.
   - Immediate trust signals: "Police Verified" pill, "Super Artisan" badge, 4.9★ rating with review counts (320+), and transparent **Inspection & Visit Fee** (e.g., ₹299 or ₹199, tagged as *"adjustable in bill"*).
2. **Deep Evaluation & Portfolio Verification (`karigaar_profile_reviews`):**
   - Tapping the craftsman opens their full profile.
   - The user inspects the **Karigaar Verified Guildsman** trust shield (Govt. ID, Police Background cleared, NSDC Certified, Calibrated Laser Tools, ₹25,000 damage protection).
   - The user browses the **Craftsmanship Showcase** (bleeding photo gallery of local work: fluted TV consoles, vintage teak dining tables, soft-close wardrobes with location tags like *Koramangala*, *HSR Layout*, *DLF*).
   - The user reviews the **Artisan Scorecard** (Punctuality: 5.0, Craftsmanship: 4.9, Sawdust & Cleanliness: 5.0) and verified client feedback.
3. **Contact Initiation & Offline Interaction:**
   - The user can trigger a direct phone call (`tel:+91...`) or WhatsApp direct message (`wa.me`).
   - The customer and artisan discuss custom requirements, schedule a site visit, or share video footage of the required work outside the platform's automated dispatch engine.
4. **Offline Scoping & Transaction Execution:**
   - The artisan arrives at the residence. Scoping, parts sourcing, labor estimates, and final payment are handled peer-to-peer (Cash, personal PhonePe/GooglePay UPI).
5. **Platform Governance & UI Controls over Path A:**
   - **Leakage Risk Management:** If the customer transacts purely offline, the platform earns no transaction commission.
   - **Platform Counter-Measures & Incentives in the UI:**
     - The profile screen emphasizes: *"Includes ₹25k Guild Warranty"* only when booking is confirmed through the platform.
     - Sticky bottom dock features a prominent **"Book Rajesh Now"** button (securing an official platform appointment with visit fee guarantee).
     - The customer understands that bypassing the platform forfeits the 30-day rework cover, rate card protection, and formal dispute escalation.

---

### 1.2 Path B: Structured Booking (Managed Marketplace / Escrow-Protected Model)

#### Objective & Market Justification
For emergency breakdowns (e.g., burning MCB fuse, burst pipe, broken lock) or complex jobs requiring guaranteed safety and accountability, customers want zero friction, fast dispatch, vetted background checks, and protected payment.

Path B provides an **Uber/Urban Company-grade managed service** with escrow security, live GPS tracking, and OTP verification.

#### User Journey Stages in Path B
1. **Service Customization & Scoping (`service_details_custom_quote`):**
   - **Trade & Task Selection:** User selects specific repair tasks via an interactive list with explicit pricing (e.g., *Short Circuit / MCB Tripping — ₹249*, *Switchboard Repair — ₹149*, *Inverter Wiring — ₹399*).
   - **Visual & Audio Scoping:** User uploads photos of the defect (e.g., `main_mcb_panel.jpg`) and can record a **15-second voice note** for the incoming artisan. This ensures the artisan arrives with the correct tools, amp fuses, or replacement parts.
   - **Arrival Slot Selector:** User chooses between *Fastest Express (Today, 45m)* or scheduled time windows (Morning 9-11 AM, Afternoon 2-4 PM, Evening 5-7 PM).
   - **Transparent Price Breakdown:** 
     - Standard Diagnostic & Visit: ₹199
     - Selected Task: ₹249
     - Karigaar Safety & Insurance Shield: ₹29
     - Total Guaranteed Estimate: ₹477
   - **Escrow Pledge:** UI clearly affirms: *"Post-Service Pay: No advance needed. Inspect work before releasing OTP payment."*
2. **Matching & Job Radar Broadcasting (`skeleton_loading_radar_sync` -> `karigaar_partner_job_radar`):**
   - Clicking *"Select Karigaar"* initiates dynamic radar matching.
   - On the partner side (`karigaar_partner_job_radar`), qualified online artisans in the zone (e.g., Sector 4 & 5 Zone) receive an **Urgent Dispatch Card**.
   - Dispatch card displays: Customer name (*Vikram Mehta*), locality (*Sector 42 Green Valley*), guaranteed payout (*₹480 + parts reimbursement*), distance (*1.8 km away, 8 mins reach time*), defect photo thumbnail, and customer voice memo preview.
   - **Time-Sensitive Acceptance:** An animated circular countdown timer gives the partner **45 seconds** to accept or pass.
   - **Pre-Flight WhatsApp Assist:** Partner can tap *"Ask Customer on WhatsApp First"* (pre-filled text) to clarify access codes or part specifications before rolling out.
3. **Dispatch & Real-Time Tracking (`active_job_live_tracking`):**
   - Once accepted, the customer's app updates to the live tracking view.
   - **Simulated Map Canvas:** Visualizes the route polyline, home destination pin, and live moving two-wheeler marker with real-time ETA (*ETA 14 min, 1.8 km*).
   - **5-Stage Step Stepper:**
     1. *Booking Confirmed* (02:10 PM - Checked)
     2. *Karigaar Dispatched* (02:18 PM - Checked)
     3. *On the Way* (Passing Cyber Hub - Live sync)
     4. *Job Execution* (Pending OTP)
     5. *Quality Sign-off* (Estimated 03:45 PM)
   - **Assigned Karigaar Card:** Shows artisan photo, verification badge, rating (4.9★), and contact buttons.
   - **In-App Communication:** 
     - Direct call button (`tel:...`)
     - In-app Quick Chat modal with canned chips (*"📍 Gate code is 8842"*, *"🅿️ Visitor parking spot #4"*, *"🔔 Ring the doorbell twice"*).
   - **Safety Start Code:** Displays a 4-digit security code (**4921**) with explicit prompt: *"Share only after Rajesh arrives"*.
4. **Doorstep Arrival, OTP Handshake & Work Execution (`partner_active_job_wallet`):**
   - The artisan arrives, greets the customer, and asks for the Start Code. Entering this code on the partner terminal transitions the booking state to `IN_PROGRESS`.
   - The partner screen activates an **Elapsed Stopwatch Counter** (*28m 14s*) and navigation shortcut.
   - **Dynamic Material & Labor Bill Builder:** 
     - Base diagnostic labor: ₹249
     - If unexpected hardware is needed, artisan taps *"Add Spare Part & Attach Invoice"*, uploads a photo of the store bill, and inputs item details (e.g., *Schneider 32A MCB: +₹380, Bill uploaded*).
     - The bill automatically updates to ₹629 (including 18% GST).
5. **Job Completion Proof, Escrow Release & Settlement (`partner_active_job_wallet` -> `active_job_live_tracking`):**
   - Upon completing repairs, the customer inspects the physical work and tests the installation.
   - Customer reveals the final **Job Completion OTP**.
   - Artisan enters the 4-digit completion code into their terminal.
   - **Instant Financial Settlement:**
     - The escrow amount is debited from customer / authorized card.
     - The partner's **Guild Wallet** is credited immediately (+₹480 / +₹629).
     - Partner can trigger an instant bank withdrawal via UPI/IMPS (₹0 fee) to their verified bank vault (*HDFC Bank •••• 2104*).
   - **Post-Job Loop:** Customer receives automated post-job review request and WhatsApp CSAT notification.

---

## 2. Cross-Journey Transitions: Bridging Path A and Path B

A critical insight from the UI designs is that **Path A and Path B are not mutually exclusive silos — they are mutually reinforcing and interoperable.**

```
                     ┌────────────────────────────────────────┐
                     │          CUSTOMER INTERACTION          │
                     └───────────────────┬────────────────────┘
                                         │
              ┌──────────────────────────┴──────────────────────────┐
              ▼                                                     ▼
    [Path A: Direct Browse]                               [Path B: Live Request]
    Customer calls artisan                                Customer submitsMCB fix
    from Profile Directory                                through Booking Flow
              │                                                     │
              │                                                     │
              ▼                                                     ▼
     ┌─────────────────┐                                   ┌─────────────────┐
     │ Artisan Arrives │                                   │ Artisan Accepts │
     │ at Customer Home│                                   │ on Job Radar    │
     └────────┬────────┘                                   └────────┬────────┘
              │                                                     │
              │ ◄─── TRANSITION 1: Retroactive Escrow Lock ─────────┤
              │      (Artisan/Customer books formal ticket         │
              │       on-site to unlock ₹25k warranty & cover)      │
              │                                                     │
              ├────── TRANSITION 2: Pre-Flight Scoping ───────────► │
              │      (Partner uses WhatsApp link to clarify         │
              │       parts before dispatch, keeping booking active)│
              │                                                     │
              ▼                                                     ▼
     ┌─────────────────┐                                   ┌─────────────────┐
     │ Uninsured P2P   │                                   │ Full Karigaar   │
     │ Risk (No Cover) │                                   │ Escrow & Shield │
     └─────────────────┘                                   └─────────────────┘
```

### Transition 1: Path A to Path B (Retroactive On-Site Formalization)
- **Scenario:** A customer discovers master carpenter *Rajesh Sharma* on the directory (`karigaar_profile_reviews`) and calls him directly. Rajesh comes for a visit. Upon inspection, the project turns out to be a major modular kitchen fitting worth ₹18,000.
- **The Problem:** The customer is uneasy handing over cash or paying an advance without protection; the artisan wants guarantee that the customer won't withhold payment after custom cutting.
- **The Transition:** Rajesh or the customer opens the Karigaar app and selects *"Post Custom Job"* or converts the direct inquiry into a formal **Structured Booking**.
- **Value Realized:**
  - Customer gets ₹25,000 Guild Damage Protection and 30-day rework warranty.
  - Customer funds the project into Karigaar Escrow (safe deposit).
  - Artisan gets guaranteed payment release upon Completion OTP, plus milestone credits toward their *Master Guildsman Tier* (0% platform commission).

### Transition 2: Path B to Path A (Pre-Flight WhatsApp Scoping)
- **Scenario:** Customer books an emergency MCB repair through Path B (`service_details_custom_quote`). 
- **The Problem:** The artisan is unsure whether it is a single-phase 16A breaker or a three-phase 63A industrial isolator. Rolling out without the right part risks a wasted trip.
- **The Transition:** In `karigaar_partner_job_radar`, the artisan taps *"Ask Customer on WhatsApp First"*.
- **Value Realized:** The interaction temporarily utilizes informal WhatsApp chat to exchange photos/videos of the distribution board, while **keeping the platform booking state machine alive**. The dispatch remains tracked, the OTP remains valid, and payment remains secured in escrow.

---

## 3. Systematic Mapping of All 12 UI Screens

The table below connects every screen in `stitch_karigaar_app_ui` to its role in Path A, Path B, or Shared Infrastructure:

| # | Screen Directory / Artifact | Primary Path / Domain | Persona Target | Core Architectural Purpose & Key Components | Transitions & Next Steps |
|---|-----------------------------|-----------------------|----------------|---------------------------------------------|--------------------------|
| **1** | `karigaar_app_icon_logo` | Shared Brand Asset | All Personas | Visual brand identity. Hexagonal slate shield (`#0F172A`/`#1E293B`), amber border (`#F59E0B`), verified emerald check (`#10B981`), and central plumb-line compass. | Splash screens, app icon, header branding. |
| **2** | `login_whatsapp_onboarding` | Shared Auth Infrastructure | Customer & Artisan | Persona entry point with dual role selector tabs (*Homeowner: Hire an Expert* vs *Karigaar: Work & Earn*). WhatsApp 1-tap OTP primary action, +91 10-digit mobile input fallback, Hindi/English language toggle, NSDC/Bank-grade trust strip. | Submitting mobile triggers `whatsapp_otp_verification_modal`. Toggling "Karigaar" reveals partner earnings promo banner. |
| **3** | `whatsapp_otp_verification_modal` | Shared Auth Infrastructure | Customer & Artisan | Security verification sheet. 6-digit OTP boxes with auto-detect, 42s resend countdown timer, "Send via SMS" fallback channel, phone edit button. | On verification success, routes Customer to `home_discovery` or Artisan to `create_account_artisan_registration` / `karigaar_partner_job_radar`. |
| **4** | `create_account_artisan_registration` | Partner Infrastructure | Artisan Partner | Multi-step artisan onboarding (Step 1 of 3: Profile & Trade). Trade category selector (6 guilds), Aadhaar/Trade Card photo dropzone with 72% simulated auto-verification bar, locality picker, experience tier selector (1-3 yrs, 3-5 yrs, 5-10 yrs, 10+ Master), WhatsApp alert opt-in, referral code accordion. | Submitting triggers OTP verification, then queues profile in Super Admin's `super_admin_portal` verification queue. |
| **5** | `skeleton_loading_radar_sync` | Telemetry & Infrastructure | Customer & Partner | Shimmer loading and cold-start state. Telemetry search bar skeleton, radar pulse sensor graphic with ping waves, category grid skeleton, floating status pill (*"Connecting to Karigaar Guild... WhatsApp Gateway Synced 99.8%"*). | Transitions to `home_discovery` (Customer) or `karigaar_partner_job_radar` (Artisan) once network telemetry handshakes complete. |
| **6** | `home_discovery` | Path A & Path B Dual Launchpad | Customer | Main consumer dashboard. Header location picker (*Sector 4*), Emergency 24x7 Quick-Assist banner (*dispatched in 25 mins*), 8-guild category grid, Karigaar Shield 3-pillar trust strip (Police Vetted, Rate Card, 30-Day Guarantee), **Top Masters Nearby** cards with visit fees and Hire CTA (Path A), Curated Guild Packages (fixed maintenance), Custom quote prompt. | Tapping craftsman leads to `karigaar_profile_reviews` (Path A). Tapping Emergency or Category leads to `service_details_custom_quote` (Path B). |
| **7** | `service_details_custom_quote` | Path B: Structured Booking | Customer | Scoping and pricing engine for Path B. Interactive issue selector with dynamic math (MCB ₹249, Sockets ₹149, Inverter ₹399), photo upload slot (`main_mcb_panel.jpg`), 15s voice memo recorder, arrival slot carousel (*Fastest: Today 45m* vs calendar days), payment breakdown with post-service escrow pledge, sticky bottom dock. | Tapping "Select Karigaar" matches nearby partners and triggers broadcast to `karigaar_partner_job_radar`. |
| **8** | `karigaar_partner_job_radar` | Path B: Artisan Matching | Artisan Partner | Live job broadcast terminal for artisans. Active/Paused duty toggle, daily earnings metrics bento (₹1,850 today, 3 jobs, 98% acceptance), WhatsApp dual-sync callout banner, **Urgent Dispatch Card** with live 45s circular SVG countdown timer, defect photo, voice memo prompt, WhatsApp direct assist link, Accept / Pass buttons, and Nearby Job Radar broadcast feed. | Accepting dispatch locks gig, transitions customer to `active_job_live_tracking`, and sets partner job state to en route. |
| **9** | `active_job_live_tracking` | Path B: In-Flight Execution | Customer | Live execution cockpit for customer. Top SOS help button, simulated GPS street map with route polyline and moving two-wheeler marker (ETA 14 min), 5-step status stepper, assigned master craftsman card, **Security Start Code (4921)**, Call button, in-app Quick Chat drawer with canned access chips, ₹10k Guild Protection badge, expandable Booking Breakdown accordion, live tracking share with family. | Transitions to `partner_active_job_wallet` completion flow upon artisan arrival. |
| **10** | `partner_active_job_wallet` | Path B: Execution & Settlement | Artisan Partner | Artisan active job terminal and financial dashboard. Status banner (*Job #KG-8842, In Progress*), live elapsed stopwatch counter, customer address navigation, Call & WhatsApp chat buttons, **Material & Labor Bill Builder** (base labor + add spare parts with photo invoice), **Job Completion OTP input** (4 digits), Guild Tier progress gauge (*Gold -> Master Guildsman 42/50 jobs*), Guild Wallet balance (₹4,620 cleared), instant IMPS withdrawal button, transaction ledger. | Entering completion OTP releases escrow payment, credits wallet, and triggers automated CSAT review prompt. |
| **11** | `karigaar_profile_reviews` | Path A & Reputation Engine | Customer | Comprehensive master craftsman profile. Hero squircle portrait, PRO badge, metric trio (4.95★, 11+ yrs exp, 1,240+ completed), Karigaar Verified Guildsman triple-screened trust shield, 6 craft specializations, Craftsmanship Showcase photo carousel of past work, 3-bar Artisan Scorecard, verified client testimonials, sticky dock with ₹299 visit fee, ₹25k warranty tag, and "Book Rajesh Now" CTA. | Book Now enters Path B checkout; Call/WhatsApp initiates Path A direct contact. |
| **12** | `super_admin_portal` | Governance & Operations | Super Admin (Ops) | Platform command center. HQ Ops live stream (142 active dispatches, 89 available artisans, 0.2% dispute rate), 2x2 KPI grid (Daily GMV ₹1,84,500, 328 completed jobs, 18 pending KYC, 1,420 WA outbound), Surge Grid Alert heatmap (Surge 1.4x in DLF Phase 4), Category volume breakdown bar, **Priority Guild Verification Queue** (Approve/Reject Mohd. Salim; Review Ramesh Verma's tool calibration), WhatsApp Dispatcher emergency surge broadcast tool, automated CSAT tracker (94% 5-Star). | Approves/rejects artisan KYC, triggers emergency zone broadcasts, monitors platform safety and dispute escalation. |

---

## 4. Persona End-to-End User Journeys

```
CUSTOMER JOURNEY
[ Discovery ] ──► [ Scoping / Quote ] ──► [ Live Dispatch ] ──► [ Doorstep Work ] ──► [ OTP & Review ]
 home_discovery    service_details         active_job_live       partner_active job    karigaar_profile
                                           tracking              wallet (interaction)  reviews

ARTISAN JOURNEY
[ Registration ] ──► [ Job Radar ] ──► [ En Route / WhatsApp ] ──► [ On-Site Execution ] ──► [ Wallet Settlement ]
 create_account       partner_job_radar active_job_live            partner_active_job         partner_active_job
 artisan_reg                            tracking (partner side)    wallet                     wallet (IMPS)

SUPER ADMIN GOVERNANCE JOURNEY
[ KYC Ingestion ] ──► [ Compliance Review ] ──► [ Live Grid Ops ] ──► [ Surge Broadcast ] ──► [ Dispute / CSAT ]
 create_account queue  super_admin_portal        super_admin_portal    super_admin_portal      super_admin_portal
```

---

### 4.1 Persona 1: Homeowner / Customer Journey

#### Sub-Persona A: Urgent Emergency Breakdown (Pooja / Vikram)
- **Trigger:** Kitchen MCB trips repeatedly with visible sparks near the oven; refrigerator and lighting circuits lose power on a hot afternoon.
- **Phase 1: Entry & Auth (`login_whatsapp_onboarding`, `whatsapp_otp_verification_modal`):**
  - Customer taps Karigaar. Selects *"Homeowner: Hire an Expert"*.
  - Taps *"Instant Login with WhatsApp"*. A 6-digit OTP auto-detects in the modal sheet. Customer is authenticated in under 8 seconds.
- **Phase 2: Discovery & Selection (`home_discovery`, `service_details_custom_quote`):**
  - Customer sees the amber **Emergency 24x7** banner (*"Urgent Breakdown? Dispatched within 25 mins"*).
  - Taps *"Book Fast"*. Screen transitions to `service_details_custom_quote`.
  - Customer checks *"Short Circuit / MCB Tripping (₹249)"*.
  - Taps camera icon: snaps photo of the burnt distribution panel.
  - Holds microphone icon: records 8-second voice memo (*"Main switch keeps falling down with clicking sound"*).
  - Selects *"Fastest: Today, 45m"*. Total estimate displayed: ₹477 (Visit ₹199 + Task ₹249 + Safety Shield ₹29).
  - Taps *"Select Karigaar"*. The button displays an animated spinner (*"Finding Karigaars..."*) and matches within seconds.
- **Phase 3: Live Tracking & Pre-Arrival (`active_job_live_tracking`):**
  - Screen displays live map showing artisan *Rajesh Kumar* riding on a two-wheeler, 1.8 km away (ETA 14 min).
  - Customer opens in-app chat drawer, taps quick chip: *"📍 Gate code is 8842"*. Rajesh acknowledges via WhatsApp dual-sync.
  - App displays **Security Start Code: 4921**.
- **Phase 4: Doorstep Execution & Verification:**
  - Rajesh arrives wearing his Guild uniform and badge. Customer verifies his face and provides code `4921`.
  - Rajesh diagnoses a burnt 32A breaker, adds the spare part to his bill builder, and uploads the hardware shop invoice (+₹380).
  - Customer receives bill update notification (Total: ₹629).
  - Repair is completed. Power is restored, safety earth leakage tested.
- **Phase 5: Release & Feedback:**
  - Customer reviews completed panel, approves the ₹629 total, and shares the 4-digit Completion OTP.
  - Payment is deducted from customer's card/UPI without cash handling.
  - Customer receives a WhatsApp message with the official GST invoice and a 5-star rating prompt.

---

#### Sub-Persona B: Planned Home Craftsmanship / Renovation (Amit)
- **Trigger:** Planning a custom modular TV console and wardrobe alignment in a newly purchased flat.
- **Phase 1: Exploration & Evaluation (`home_discovery`, `karigaar_profile_reviews`):**
  - Amit selects the "Carpenter" guild icon from the 8-grid on `home_discovery`.
  - Scrolls through "Top Masters Nearby", comparing ratings and experience.
  - Opens *Rajesh Kumar Sharma's* profile (`karigaar_profile_reviews`).
  - Studies Rajesh's portfolio images of oak fluted paneling and teak dining table restoration.
  - Verifies Rajesh's credentials (NSDC Certified, Police Cleared, 4.95★ over 418 reviews).
- **Phase 2: Engagement Choice:**
  - **Path A Choice:** Amit taps the phone icon and calls Rajesh directly to discuss timber types (burma teak vs engineered oak) and schedules an informal preliminary visit.
  - **Path B Formalization:** After Rajesh visits and quotes ₹14,000 for materials and labor, Amit books Rajesh through the platform's custom booking flow to ensure the ₹25,000 Guild Damage Cover and 30-day rework warranty remain active.

---

### 4.2 Persona 2: Artisan Partner (Karigaar) Journey

#### Exemplar: Rajesh Kumar (Master Carpenter) / Tariq Anwar (Certified Electrician)
- **Phase 1: Onboarding & Guild Accreditation (`create_account_artisan_registration`):**
  - Artisan selects *"I am a Karigaar"* on `login_whatsapp_onboarding`.
  - Enters full legal name (matching Aadhaar) and WhatsApp mobile number.
  - Selects primary trade: *Electrician*.
  - Uploads front photo of Aadhaar Card into the dropzone (screen shows automated OCR verification progress).
  - Sets primary working locality: *Sector 48, Sohna Road, Gurugram*.
  - Chooses experience tier: *10+ Master*. Opts into WhatsApp Dispatch Dispatcher. Applies referral code *GUILD500*.
  - Submits registration via WhatsApp OTP. Profile goes into pending status in Super Admin's queue.
- **Phase 2: Duty Activation & Job Radar (`karigaar_partner_job_radar`):**
  - Once verified by Admin, artisan opens app, flips the duty switch from *Paused* to *Active*.
  - Header displays green blinking dot: `ONLINE` (Gurugram Sector 4 & 5 Zone).
  - Bento metric strip shows today's earnings: ₹1,850, 3 jobs completed, 98% acceptance (Master Tier).
- **Phase 3: Dispatch Alert & Acceptance:**
  - An emergency dispatch pops up with an audio chime and amber ambient glow: *Emergency Short Circuit & MCB Trip (Vikram Mehta • Sector 42 Green Valley)*.
  - Payout: ₹480 guaranteed (+ parts reimbursement). Distance: 1.8 km (8 mins reach time).
  - The circular SVG countdown timer sweeps from 45 seconds down.
  - Artisan taps *"Ask Customer on WhatsApp First"* to ensure the customer has switched off the main switch.
  - Taps *"Accept Dispatch (38s)"*.
  - The button turns green: *"Dispatch Confirmed! Opening GPS..."* and launches turn-by-turn navigation.
- **Phase 4: Doorstep Execution & In-Job Billing (`partner_active_job_wallet`):**
  - Artisan reaches Sector 42, rings doorbell. Customer shares Start OTP `4921`.
  - Artisan inputs OTP; the screen transitions to *Job #KG-8842 In Progress* with live elapsed timer.
  - Artisan inspects distribution board, finds a melted 32A breaker.
  - Walks to neighborhood electrical hardware shop, purchases Schneider 32A MCB for ₹380.
  - Taps *"Add Spare Part & Attach Invoice"*, takes a photo of the shop receipt, inputs ₹380.
  - Total updates to ₹629. Customer accepts the revised estimate.
  - Artisan installs breaker, tests load with digital multimeter.
- **Phase 5: Completion & Instant Payout:**
  - Artisan requests the 4-digit Job Completion OTP from customer and enters it into the screen.
  - App displays green success check: *"Verify & Collect ₹629"*.
  - Artisan's Guild Wallet immediately reflects the credit. Available balance increases to ₹4,620.
  - Artisan taps *"Withdraw to Bank via UPI / IMPS (₹0 Fee)"*. Funds transfer to his linked HDFC account in under 30 seconds.
  - Milestone gauge updates: *43 / 50 Jobs completed* toward unlocking 0% commission tier.

---

### 4.3 Persona 3: Super Admin Governance Journey

#### Exemplar: Operations Manager / Guild Master at HQ
- **Phase 1: Real-Time Network Surveillance (`super_admin_portal`):**
  - Ops manager monitors the HQ Ops Stream:
    - 142 Active Dispatches across pilot zones
    - 89 Available Artisans on duty
    - 0.2% Dispute Rate
    - Daily GMV: ₹1,84,500 (+14% vs yesterday)
    - Completed jobs: 328 (identifying peak hours between 11 AM – 2 PM)
  - Category Volume Mix bar shows current demand distribution: Electrician 38%, Carpenter 26%, Plumber 20%, Appliance 16%.
- **Phase 2: Artisan KYC Verification Queue Processing:**
  - Queue shows **18 pending registrations** (5 priority SLA).
  - Candidate 1: *Mohd. Salim (Master Plumber, 8 yrs exp)*.
    - Badges verified: Aadhaar + Police background check cleared, NSDC Grade-A certification attached.
    - Admin reviews documents and clicks *"Approve Guild"*. The card dims with optimistic visual confirmation, and an automated WhatsApp welcome message with login link is triggered to Salim.
  - Candidate 2: *Ramesh Verma (AC & Heating, 4 yrs exp)*.
    - Flagged badge: *Tool Calibration Due* (multimeter certificate expired).
    - Admin clicks *"Review Documents & Tools"*, prompting a WhatsApp notification to Ramesh requesting an updated tool calibration slip before dispatch activation.
- **Phase 3: Surge Grid Monitoring & Emergency Dispatch Broadcast:**
  - The Live Dispatch Radar flags a **Surge Grid Alert**: High demand in *DLF Phase 4 & Cyber City* with average ETA stretched to 34 minutes due to an afternoon thunderstorm and power tripping.
  - Surge is automatically set to 1.4x.
  - Admin utilizes the **WhatsApp Dispatcher Pipeline**:
    - Selects campaign: *"DLF 4 Electrician Emergency (Radius 5.5 km)"*.
    - Prompt: *"Notify 24 standby certified technicians with ₹250 bonus surcharge"*.
    - Clicks *"Broadcast Surge Alert via WhatsApp"*. The button animates and confirms: *"Broadcast Sent to 24 Artisans"*.
    - Within 4 minutes, 9 standby electricians toggle duty to Active, normalizing zone ETAs down to 18 minutes.
- **Phase 4: Dispute Resolution & CSAT Quality Audit:**
  - Admin reviews the Automated Post-Job CSAT telemetry: 94% 5-Star across 1,180 responses.
  - If a dispute is raised (0.2% edge cases), admin inspects the escrow audit trail: before/after job photos, hardware invoice scans, and WhatsApp chat transcripts to adjudicate claim releases from the ₹25,000 Guild Damage pool.

---

## 5. Communication Protocol: WhatsApp-First Architectural Spine

A prominent design pattern across all 12 screens is the **deep integration with WhatsApp**. Rather than attempting to force blue-collar artisans and casual customers to rely exclusively on native push notifications (which frequently suffer from OEM battery killer closures on budget Android devices), Karigaar uses WhatsApp as its real-time messaging spine.

```
┌────────────────────────────────────────────────────────────────────────┐
│                      WHATSAPP BOT & GATEWAY SYNC                       │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
           ┌────────────────────────┴────────────────────────┐
           ▼                                                 ▼
┌─────────────────────────────┐                   ┌─────────────────────────────┐
│      Customer Channels      │                   │       Partner Channels      │
└──────────┬──────────────────┘                   └──────────┬──────────────────┘
           │                                                 │
 • 1-Tap OTP login via WA                          • Real-time dispatch alerts
 • Order receipt & GST invoice                     • Customer voice memo streaming
 • Live GPS tracking link                          • Exact gate pass PINs & location
 • Automated CSAT survey                           • Daily earnings settlement slips
 • Concierge support hotline                       • Emergency surge broadcast calls
```

### Key Technical & Operational Touchpoints
1. **Instant Onboarding Auth (`login_whatsapp_onboarding`, `whatsapp_otp_verification_modal`):**
   - High delivery reliability compared to standard Indian telecom DLT SMS headers.
   - Fallback to SMS is preserved if WhatsApp message is undelivered within 42 seconds.
2. **Dual-Sync Dispatcher (`karigaar_partner_job_radar`):**
   - In-app text: *"Bot Active Dual Sync: Customer voice notes, gate pass PINs, and exact GPS pins stream live to your WhatsApp."*
   - Enables the artisan to listen to the customer's problem description while riding or preparing tools without keeping the phone screen permanently unlocked.
3. **Pre-Dispatch Scoping (`karigaar_partner_job_radar`):**
   - Direct deep-link (`https://wa.me/?text=...`) allowing the artisan to ask quick technical questions before traveling, reducing cancelled visits.
4. **Daily Settlements & Slips (`create_account_artisan_registration`, `partner_active_job_wallet`):**
   - *"Send Weekly Earnings Summary to WhatsApp"* provides transparent financial accounting for artisans who may not use accounting software.
5. **HQ Surge Alerts (`super_admin_portal`):**
   - High-throughput outbound broadcast pipeline capable of reaching dormant verified partners in specific pin codes during demand surges.

---

## 6. Synthesis of Critical Workflow Decision Points for the Founder

Based on this workflow and journey analysis, the founder must address five pivotal decisions prior to engineering implementation:

1. **Direct Contact Disclosure Policy (Path A vs Path B Balance):**
   - *Question:* Should artisan phone numbers on `karigaar_profile_reviews` be completely exposed (free directory), masked via virtual PBX numbers, or gated behind a nominal "Lead Unlock" fee?
   - *Implication:* Full open phone disclosure maximizes initial user adoption but creates acute platform disintermediation (leakage). Virtual number masking protects privacy and allows tracking, while the ₹25k Guild Warranty serves as the primary carrot to encourage platform checkout.
2. **Single Unified Mobile App vs Two Separate Binaries:**
   - *Evidence from UI:* `login_whatsapp_onboarding` and `create_account_artisan_registration` contain a **Segmented Role Switcher** (*Homeowner* vs *Karigaar*), suggesting a unified app concept.
   - *Architectural Trade-off:* A single app simplifies discovery and allows dual-role users (e.g. an electrician who also hires a plumber), but increases app binary size (background GPS tracking, radar audio, bento dashboards). Separate apps (*Karigaar Customer* and *Karigaar Partner*) optimize runtime memory and battery for artisans on low-end Android phones.
3. **Booking State Machine Timeout & Cancellation Penalties:**
   - *Evidence from UI:* The Job Radar incorporates a strict **45-second acceptance timer**.
   - *Policy Requirement:* What happens if all nearby artisans pass? How long before the job cascades to the next 5 km radius? If a customer cancels after an artisan has traveled for 10 minutes, what transit compensation is automatically debited from the customer's account?
4. **Dispute Adjudication & Escrow Release Rules:**
   - *Evidence from UI:* The platform uses dual OTPs (Start OTP `4921` and Completion OTP).
   - *Policy Requirement:* If a customer refuses to share the Completion OTP due to dissatisfaction with parts quality or minor defects, what is the SLA for Super Admin intervention? Does the platform hold the labor fee while releasing the material reimbursement immediately?
5. **WhatsApp API Cost Management:**
   - *Evidence from UI:* WhatsApp is used for login OTP, job alerts, voice note delivery, gate PINs, settlement slips, surge broadcasts, and CSAT surveys.
   - *Cost Implication:* Meta charges per 24-hour conversation category (Authentication, Utility, Marketing, Service). The system architecture must batch transactional messages under active service windows to prevent runaway per-job messaging costs.

---

## Conclusion
The Karigaar platform design successfully balances the tactile, human-centric trust required in the Indian craftsman ecosystem with modern algorithmic dispatch and escrow protection. By clearly structuring **Path A** for discovery-driven, high-autonomy interactions and **Path B** for emergency, escrow-guaranteed dispatches, Karigaar positions itself not merely as a gig-economy broker, but as a digital guild modernizing India's informal trades.
