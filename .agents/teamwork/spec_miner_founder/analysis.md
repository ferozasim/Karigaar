# Karigaar Platform — Founder Requirements & Business Architecture Specification
**Phase 0 Review: Discovery, Strategic Decisions & Operating Rules Baseline**

---

## 1. Executive Summary & Review Scope

This specification provides an exhaustive, authoritative breakdown of all business rules, architectural trade-offs, and strategic decisions required from the founder before engineering implementation begins. 

Our findings are synthesized from a rigorous audit of:
1. **The 12 Core Reference UI Screens & Prototypes** located in `c:\Users\asimf\Downloads\stitch_karigaar_app_ui\stitch_karigaar_app_ui` (including `home_discovery`, `service_details_custom_quote`, `active_job_live_tracking`, `create_account_artisan_registration`, `login_whatsapp_onboarding`, `whatsapp_otp_verification_modal`, `karigaar_partner_job_radar`, `partner_active_job_wallet`, `karigaar_profile_reviews`, `super_admin_portal`, `skeleton_loading_radar_sync`, and `karigaar_app_icon_logo`).
2. **The "Karigaar Artisan Trust" Design System** (`DESIGN.md`), defining the visual hierarchy (Tactile Modernism, Slate `#0F172A`, Artisan Amber `#F59E0B`, Verified Emerald `#10B981`, Plus Jakarta Sans, Inter tabular figures, and minimum 48px touch targets).
3. **The Baseline Architecture Requirements** codified in `ORIGINAL_REQUEST.md`, spanning the dual-path engagement model (**Path A: Direct Contact & Bidding** vs. **Path B: Structured Booking & Escrow Dispatch**).

To enable rapid founder sign-off, every open decision is presented with concrete options, trade-off matrices, architectural/cloud implications, and a **Recommended Default**.

---

## 2. Review of Reference Materials & UI Screen System Mapping

The Karigaar platform design represents a hybrid marketplace linking urban Indian households with vetted, skilled guild artisans. The 12 screens map into a cohesive multi-actor ecosystem:

| Screen Identifier | Target Actor | Primary Purpose & Observed UI Components | Architectural / Data Touchpoint |
|---|---|---|---|
| `home_discovery` | Customer | Service taxonomy navigation (8 primary trade guilds), emergency 25-min booking banner, live top-rated artisans nearby, curated preventive bundles (AC jet clean, electrical audit), dual path triggers ("Hire Artisan" vs "Post Job"). | Locality-based geospatial query, dynamic rate card cache, Redis geo-radius lookup. |
| `service_details_custom_quote` | Customer | Configurable task picker (MCB trip ₹249, switchboard ₹149, fan ₹199), standard diagnostic & visit fee (₹199 adjustable in bill), ₹29 safety insurance shield, audio voice memo recorder (15s), visual photo upload, guaranteed arrival slots (Today 45m express). | Multi-media S3/Cloud Storage upload, pricing engine breakdown, slot booking lock. |
| `active_job_live_tracking` | Customer | Real-time map telemetry, 5-stage milestone stepper (Confirmed → Dispatched → On the Way → Execution → Quality Sign-off), 4-digit Security Start Code (`4921`), direct call link, in-app messaging modal with canned gate/parking chips, SOS emergency button, ₹10,000 damage cover badge. | WebSockets / MQTT live location stream, secure start OTP verification, WebRTC/Twilio call masking gateway. |
| `create_account_artisan_registration` | Artisan / Customer | 3-step registration wizard, English/Hindi language toggle, customer vs artisan role switcher, trade picker (6 trades), trade experience tiers (1-3 yrs up to 10+ master), Aadhaar photo upload with 72% OCR auto-verification, WhatsApp broadcast opt-in, referral code entry. | OCR document parsing (DigiLocker/HyperVerge), user profile collection, multilingual i18n store. |
| `login_whatsapp_onboarding` | Both | 1-tap WhatsApp OAuth/Instant Login, mobile number input with SMS fallback, role-segmented onboarding tabs (Homeowner vs Karigaar), trust badges (NSDC partner, 256-bit encrypted, guaranteed rates), WhatsApp Concierge support link. | WhatsApp Cloud API webhook, SMS gateway fallback (DLT registered), JWT session issuer. |
| `whatsapp_otp_verification_modal` | Both | Bottom sheet modal, 6-digit OTP input boxes with auto-detect, 42s countdown timer, "Send via SMS" fallback channel, number edit shortcut. | Redis OTP cache with TTL and rate limiting (max 3 retries / 15 mins). |
| `karigaar_partner_job_radar` | Artisan (Partner) | Live duty toggle (Online/Active), earnings Bento (Today ₹1,850, 3 jobs, 98% acceptance), WhatsApp Bot Dual Sync alert, 45s countdown emergency dispatch card with guaranteed payout (₹480 + parts), customer audio memo & photo thumbnail, pass vs accept buttons, nearby job radar feed with filters. | High-frequency Redis Pub/Sub broadcast, geofencing radar listener, 45s timeout worker. |
| `partner_active_job_wallet` | Artisan (Partner) | Live job execution clock (elapsed 28m 14s), customer call/WhatsApp direct links, Material & Labor bill builder (Diagnostic ₹249 + Schneider 32A MCB ₹380 with invoice upload = ₹629 with 18% GST), 4-digit completion OTP entry, Guild Tier gauge (Gold → Master 0% commission), Wallet balance (₹4,620 cleared), instant UPI/IMPS withdrawal (₹0 fee). | Transactional ledger, material bill invoice OCR, RazorpayX / Cashfree Payouts API. |
| `karigaar_profile_reviews` | Customer | Master craftsman showcase, ₹299 inspection visit fee with ₹25k warranty, triple verification badges (Govt ID, NSDC Certified, ₹25k damage protection, calibrated tools), past work portfolio carousel (before/after photos, tagged localities), verified client reviews with granular sub-scores (punctuality 5.0, cleanliness 5.0), instant booking CTA. | Artisan public profile service, media CDN, rating aggregation engine. |
| `super_admin_portal` | Operations Admin | Mobile Super Admin console, live dispatch pulse (142 active, 89 available, 0.2% disputes), 2x2 KPI grid (Daily GMV ₹1.84L, 328 jobs, 18 guild queue, 1,420 WA outbound), 1.4x Surge Grid Alert (DLF Phase 4 / Cyber City), job volume breakdown, Artisan verification approval queue (Aadhaar, Police check, tool calibration), WhatsApp emergency surge broadcast trigger. | Operational analytics pipeline, admin RBAC, surge pricing engine, queue orchestration. |
| `skeleton_loading_radar_sync` | Both | Telemetry search pill shimmer, radar pulse sensor graphic placeholder, optimistic loading micro-animations adhering to 60fps mobile rendering standards. | Mobile client-side caching and skeleton layout states. |
| `karigaar_app_icon_logo` | Brand Asset | Dark slate `#0F172A` squircle, artisan amber hex-frame `#F59E0B`, verified emerald check `#10B981`, tool calibration node. | Vector SVG asset deployed across mobile bundles and app stores. |

---

## 3. Decision Area 1: Pilot City Selection & Hyperlocal Operational Strategy

### 3.1 Context & UI Evidence
The reference designs explicitly specify operational coordinates and neighborhood naming in **Gurugram / NCR**:
- `home_discovery`: *"Home • 42 Green Valley, Sector 4"* and *"Top Masters in Sector 4"*.
- `active_job_live_tracking`: Map center pegged to *"42 Green Valley, Sector 48, Gurgaon, India"* and real-time status referencing *"Passing Cyber Hub"*.
- `karigaar_partner_job_radar`: *"Gurugram Sector 4 & 5 Zone"* and broadcast cards referencing *"DLF Phase 4"* and *"Sushant Lok 1"*.
- `partner_active_job_wallet`: *"Flat 402, DLF Phase 4, Gurugram"*.
- `super_admin_portal`: *"High demand in DLF Phase 4 & Cyber City"*.
- Secondary mentions in profile showcases cite Bengaluru localities (*"Indiranagar 100ft Rd"*, *"HSR Layout"*, *"Koramangala"*), representing potential expansion targets.

### 3.2 Strategic Trade-Off Analysis: Candidate Pilot Markets

| Dimension | Option 1A: Gurugram (Cyber City / Golf Course Rd / Sohna Rd) | Option 1B: Bengaluru (Indiranagar / HSR / Whitefield) | Option 1C: Mumbai / MMR (Powai / Thane / Western Suburbs) |
|---|---|---|---|
| **Customer Willingness to Pay** | **Highest in India**. High per-capita disposable income in gated condominiums; strong demand for emergency response and premium craftsmanship. | High. Tech-savvy audience accustomed to app-based home services, but high market penetration of competitors. | High. Dense apartment clusters, high emergency plumbing and electrical breakdown frequency. |
| **Artisan Supply Dynamics** | Dense artisan clusters in Old Gurugram, Sector 14, Wazirabad, and migratory artisan supply from Haryana, UP, and Rajasthan. High smartphone penetration. | Highly organized local guilds, but strong regional language barrier (Kannada vs Hindi/Tamil). | High supply density, but extreme intra-city travel friction and transit times reduce artisan dispatch radiuses. |
| **Geographic Density & Gated Societies** | **Ideal for Hyperlocal Clusters**. High concentration of high-rise condominiums (DLF, Ireo, M3M, Vatika) with predictable layout and gate security protocols. | Dispersed layout; traffic gridlock expands 2 km travel time beyond 35 minutes. | Extreme transit bottlenecks; vertical density is high but parking/access for two-wheelers is constrained. |
| **Competitive Intensity** | Moderate to High. Urban Company operates heavily, but focuses primarily on standardized salon/cleaning, leaving heavy custom craftsmanship underserved. | Very High. Urban Company, NoBroker, and local task platforms have entrenched customer bases. | High. Fragmented local contractor networks and society-approved maintenance monopolies. |

### 3.3 Operational Bounding & Clustering Model

```
[City Hub: Gurugram]
      │
      ├── Cluster Alpha (Core Pilot): DLF Phase 1-5, Golf Course Road, Cyber City
      │     └── Bounds: 5 km radius | Target Supply: 80 active artisans | Target SLA: < 25 mins
      │
      └── Cluster Beta (Phase 1B Expansion): Sohna Road, Sector 48-50, Nirvana Country
            └── Bounds: 6 km radius | Target Supply: 60 active artisans | Target SLA: < 35 mins
```

1. **Hyperlocal Clustering vs. Citywide Open Dispatch:**
   - **Hyperlocal Clustering (Recommended):** Bound the platform strictly to a contiguous 8-10 km corridor (e.g., DLF Phase 1 to Sector 48, Gurugram) during the first 90 days. Every artisan on-boarded must reside or station their base within a 4 km radius of the cluster.
   - **Citywide Launch (Avoid):** Launching across Gurugram, Faridabad, and Noida simultaneously dilutes supply liquidity, blows out arrival SLAs beyond 60 minutes, causes partner churn due to long transit times, and makes physical verification logistically unmanageable.

### 3.4 Language Architecture & Regional Dialects
- **UI Evidence:** `create_account_artisan_registration` and `login_whatsapp_onboarding` showcase an **"English / हिंदी"** toggle pill. `service_details_custom_quote` and `karigaar_partner_job_radar` feature **15-second Audio Voice Memos**.
- **The Non-Tech Artisan Reality:** Over 70% of blue-collar craft specialists in NCR communicate natively in Hindi or regional dialects (Haryanvi, Bhojpuri, Braj). Complex text menus cause drop-offs.
- **Architectural Requirement:**
  - **Bilingual Interface:** Customer client defaults to English with Hindi toggle; Partner client defaults to Hindi with English toggle.
  - **Voice-First Messaging:** As shown in `service_details_custom_quote`, customers can record audio notes; the backend integrates WhatsApp voice note relay so artisans can listen to customer requirements with 1 tap.
  - **Visual Iconography & Number Emphasis:** Use high-contrast numeric price fonts (`Inter` tabular figures) and bold Material Symbols icons so semi-literate artisans can navigate jobs by color, price, and audio.

### 3.5 Founder Decision 1 Summary
- **Open Decision:** Which city and specific micro-clusters will serve as the Phase 0/1 launch ground, and what are the exact geographic bounding coordinates?
- **Recommended Default:** **Gurugram (Sub-zone: DLF Phase 1–5, Cyber City, and Sector 42–48 corridor)**. Restrict customer booking availability strictly to these pincodes (`122002`, `122009`, `122018`). Default app language to bilingual **Hindi + English**, with WhatsApp audio memo streaming as the primary communication vector.

---

## 4. Decision Area 2: Initial Launch Categories & Service Taxonomy

### 4.1 Service Taxonomy & Phasing Strategy
The UI screens feature an 8-trade grid on `home_discovery` and a 6-trade selector on `create_account_artisan_registration`. To ensure supply liquidity and operational quality, the founder must decide which trades launch on Day 1 versus subsequent phases.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        LAUNCH TAXONOMY MATRIX                          │
├───────────────────────────────────┬────────────────────────────────────┤
│ Wave 1: Core Launch Trades (Day 1)│ Wave 2: Expansion Trades (Day 90+) │
├───────────────────────────────────┼────────────────────────────────────┤
│ 1. Electrician (Sparks, MCB, Invr)│ 5. Painter (Wall Texture, Polish)  │
│ 2. Plumber (Leaks, Valves, Pumps) │ 6. Masonry/Civil (Tiles, Granite)  │
│ 3. Carpenter (Locks, Hinges, Wood)│ 7. Pest Guard                      │
│ 4. AC & Appliance Repair          │ 8. Locksmith & Security Systems    │
└───────────────────────────────────┴────────────────────────────────────┘
```

#### Detailed Breakdown of Wave 1 Trades:
1. **Electrician Guild:**
   - *Emergency Scope:* MCB tripping, burning smell, short-circuits, power surges.
   - *Standard Scope:* Inverter wiring, switchboard replacement, fan/chandelier hanging.
   - *Rate Model:* Upfront diagnostic fee (₹199) + standard itemized task card (₹149 - ₹399) + spare parts at actuals.
2. **Plumber Guild:**
   - *Emergency Scope:* Burst pipes, overflowing overhead tanks, blocked main drains.
   - *Standard Scope:* Tap/angle valve replacement, sanitary ware repair, pump maintenance.
   - *Rate Model:* Upfront diagnostic fee (₹199) + itemized repair tasks (₹199 - ₹499).
3. **Carpenter Guild:**
   - *Emergency Scope:* Jammed door locks, broken security latches, fallen cabinet doors.
   - *Standard Scope:* Modular kitchen channel alignment, wardrobe hinge repair, furniture polish.
   - *Rate Model:* Inspection fee (₹299) + custom quote / labor hours for custom woodwork.
4. **AC & Appliance Repair Guild:**
   - *Standard Scope:* Split AC deep jet clean (₹599 package as seen in `home_discovery`), gas top-up, fan motor replacement.
   - *Seasonal Dependency:* Critical revenue driver during summer months (March – July in North India).

### 4.2 Task Scope Modeling: Fixed-Rate Minor Tasks vs Custom-Quote Projects
The Karigaar platform uniquely bridges two very different project types:

```
                                  CUSTOMER REQUIREMENT
                                           │
                    ┌──────────────────────┴──────────────────────┐
                    ▼                                             ▼
         [MINOR / REPAIR TASK]                        [MAJOR / CUSTOM PROJECT]
         Path B: Structured Booking                   Path A: Custom Quote & Bidding
         ──────────────────────────                   ──────────────────────────────
         • Emergency / Minor fix                      • Modular kitchen renovation
         • Fixed Diagnostic Fee (₹199-299)            • Full house rewiring
         • Guaranteed Rate Card                       • Wardrobe fabrication
         • Instant Auto-Dispatch (<25 min)            • Multi-day milestone escrow
         • Post-Service OTP Release                   • In-app quote negotiation
```

1. **Path B (Structured Booking / Standardized Tasks):**
   - Applies to predefined, repetitive tasks (e.g., MCB replacement, tap washer leak, lock repair).
   - *Pricing:* Standard visit/diagnostic fee + itemized labor card. Customer pays via escrow hold; artisan adds materials with bill upload; customer releases payment via 4-digit OTP.
2. **Path A (Custom Quote Projects):**
   - Applies to projects requiring extensive labor, custom carpentry fabrication, or full-apartment civil renovation.
   - *Pricing:* Artisan visits for site inspection (paid inspection fee ₹299, adjustable against final project bill), submits formal milestone quotation via app; platform holds milestone escrows.

### 4.3 Supply-Side Onboarding Barriers & Verification Friction per Trade

| Trade Category | Mandatory Tool Verification | Licensing / Certifications | Safety Risk Profile | Onboarding Friction Level |
|---|---|---|---|---|
| **Electrician** | Insulated pliers (1000V), Digital Multimeter, Phase tester, Wire stripper | ITI / NSDC Electrical Certificate strongly preferred; 3+ yrs field exp | High (Life safety, fire hazard) | **Medium-High**: Requires physical or video verification of insulated tool safety kit. |
| **Plumber** | Pipe wrenches (12" & 18"), Teflon tape, Hex keys, Hand drill, Pressure tester | Skill certification or master plumber reference | Medium (Water damage, flooding) | **Medium**: Straightforward practical skill check; tool checklist verification. |
| **Carpenter** | Laser level, Precision chisel set, Power circular saw, Framing square | NSDC Woodcraft Certificate / Master Guild endorsement | Low-Medium (Property/furniture damage) | **High**: Must verify past portfolio craftsmanship (as seen in `karigaar_profile_reviews`). |
| **AC / HVAC** | Pressure gauges, Vacuum pump, Gas charging manifold, Jet foam spray kit | Refrigeration & Air Conditioning (RAC) certification | High (Refrigerant gas safety, high voltage) | **High**: Verification of specialized jet service equipment required. |

### 4.4 Founder Decision 2 Summary
- **Open Decision:** Which trades launch on Day 1, what tasks qualify for instant fixed-rate booking vs custom quotation, and what are the non-negotiable tool audit criteria?
- **Recommended Default:** Launch exclusively with **Electrician, Plumber, and Carpenter** in Month 1, followed by **AC & Appliance** in Month 2. Restrict Path B instant booking to standard repair tasks with a baseline diagnostic fee (₹199 for Electrical/Plumbing, ₹299 for Carpentry). Mandate front-of-camera tool inspection during WhatsApp onboarding before an artisan can toggle "Online".

---

## 5. Decision Area 3: Single vs Separate Mobile Applications

### 5.1 Context & UI Clues in Reference Materials
The provided UI designs contain evidence pointing toward both architectural directions:
- In `login_whatsapp_onboarding` and `create_account_artisan_registration`, there is a prominent **Role Switcher Segmented Tab** (*"Homeowner / Hire an Expert"* vs. *"Karigaar / Work & Earn"*).
- Conversely, `karigaar_partner_job_radar` and `partner_active_job_wallet` display dedicated partner navigation bars (`Radar`, `My Jobs`, `Wallet`, `Guild`) with high-frequency telemetry, 45-second dispatch timers, continuous GPS tracking, and a live job stopwatch that are completely irrelevant to a homeowner.

### 5.2 Exhaustive Multi-Dimensional Comparison

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                             ARCHITECTURAL APP TOPOLOGY                                  │
├───────────────────────────────────────────┬─────────────────────────────────────────────┤
│   OPTION 1: UNIFIED SINGLE APP            │   OPTION 2: DISTINCT SEPARATE APPS          │
│   (Role Switcher in Profile/Login)        │   (Karigaar App + Karigaar Partner App)     │
├───────────────────────────────────────────┼─────────────────────────────────────────────┤
│ • Single binary in App Store / Play Store │ • "Karigaar: Home Services" (Customer)      │
│ • Homeowner & Artisan switch roles in app │ • "Karigaar Partner: Guild Radar" (Artisan) │
│ • Shared user table with role flags       │ • Distinct target personas & permissions    │
└───────────────────────────────────────────┴─────────────────────────────────────────────┘
```

#### Dimension 1: Store Discovery & App Store Optimization (ASO)
- **Option 1 (Unified):** Disastrous ASO dilution. Customer search terms (*"emergency plumber"*, *"electrician Gurgaon"*, *"carpenter service"*) clash with partner search terms (*"bijli mistri job"*, *"plumber partner app"*, *"carpenter daily earning"*). Metadata, screenshots, and keywords cannot cater effectively to both sides.
- **Option 2 (Distinct - Recommended):** Crisp ASO targeting. Customer app targets high-intent consumer keywords; Partner app targets blue-collar vocational keywords with Hindi store listings and localized vernacular screenshots.

#### Dimension 2: Binary Size, Dependencies & Background Telemetry
- **Option 1 (Unified):** Severe binary bloat. The Partner workflow requires:
  - Background Geolocation Tracking (`flutter_background_geolocation` / Android Foreground Services) with persistent sticky notifications.
  - Bluetooth / NFC / audio playback dependencies for emergency sirens and high-volume dispatch alerts.
  - Camera & OCR SDKs for invoice scanning and Aadhaar capture.
  - Bundling these into the Customer app bloats the download size from ~18MB to 45MB+, increasing customer install abandonment in mobile environments.
- **Option 2 (Distinct - Recommended):** Lean Customer App (<20MB) with standard location permissions (`ACCESS_COARSE_LOCATION` / `ACCESS_FINE_LOCATION` only while using the app). Partner App is optimized for continuous background telemetry, battery wake-locks, and offline queue synchronization.

#### Dimension 3: App Store & Google Play Review / Policy Risks
- **Option 1 (Unified - Extreme Risk):** Apple App Store Review Guideline 2.5.4 strictly prohibits background location tracking unless directly providing a core user-facing feature. If a homeowner downloads the app, iOS will flag why an on-demand consumer app requests continuous background location. Google Play will mandate an arduous "Location in the Background" declaration, risking complete app rejection.
- **Option 2 (Distinct - Safe):** The Partner App legitimately qualifies for `ACCESS_BACKGROUND_LOCATION` and `FOREGROUND_SERVICE_LOCATION` as an enterprise/gig worker dispatch tool. The Customer App never requests background location.

#### Dimension 4: UX Ergonomics & Cognitive Load for Non-Tech Artisans
- **Option 1 (Unified):** High cognitive confusion. An artisan accidentally tapping "Homeowner mode" gets lost in the consumer discovery feed, misses incoming dispatches, and calls customer support.
- **Option 2 (Distinct - Recommended):** The artisan launches "Karigaar Partner" and is immediately met with the high-contrast **Job Radar** (`karigaar_partner_job_radar`), the big green **ONLINE / ACTIVE** switch, and their daily wallet earnings. Zero extraneous navigation.

#### Dimension 5: Codebase Architecture & Engineering Velocity
- **Founder Dilemma:** "Does building two apps mean writing double the code?"
- **Answer: No.** Using a modern cross-platform framework (Flutter or React Native monorepo), both apps share 70%+ of their foundation:
  - Shared Core Design System (colors, Plus Jakarta Sans, Inter typography, buttons, cards from `karigaar_artisan_trust`).
  - Shared Data Models, API client, WebSockets, and Authentication modules.
  - Separate application shells (`karigaar_customer_app` and `karigaar_partner_app`) importing the shared packages.

### 5.3 Trade-Off Matrix

| Evaluation Criteria | Option 1: Unified App | Option 2: Distinct Mobile Apps |
|---|---|---|
| **ASO & User Acquisition** | Poor (Diluted keywords, conflicting reviews) | **Superior** (Targeted campaigns, distinct ratings) |
| **App Binary Size** | Large (45MB+ due to partner background libraries) | **Optimized** (Customer ~18MB, Partner ~25MB) |
| **Battery & Background Location Permissions** | High risk of Google/Apple rejection | **Compliant** (Proper declarations per persona) |
| **Artisan Usability** | Confusing (Accidental mode switching) | **Dead Simple** (Launches directly into Job Radar) |
| **Development Complexity** | Lower initial scaffolding; high runtime state complexity | Clean separation of concerns with shared monorepo UI kit |

### 5.4 Founder Decision 3 Summary
- **Open Decision:** Deploy a single unified binary with a role switcher, or launch two separate binaries on Google Play and Apple App Store?
- **Recommended Default:** **Option 2: Distinct Mobile Applications** (`Karigaar: Home Services` for Customers and `Karigaar Partner` for Artisans) structured within a **single Flutter/React Native monorepo** sharing a common design system and API client. The Super Admin Console remains a dedicated responsive web portal (`super_admin_portal`).

---

## 6. Decision Area 4: Direct Contact Disclosure Policies & Disintermediation Control

### 6.1 The Disintermediation Dilemma in Home Services
The fatal vulnerability of home service marketplaces is **platform leakage (disintermediation)**:
1. Customer finds an artisan via the platform.
2. The artisan arrives, performs the job, and says: *"Bhaiya, next time call me directly on WhatsApp; I will give you a 20% discount and we both avoid the platform commission."*
3. Both customer and artisan churn from the platform for all recurring work.

### 6.2 UI Analysis of Contact Touchpoints
- In `active_job_live_tracking`, the action button has a raw `href="tel:+919876543210"` link and an in-app chat drawer.
- In `partner_active_job_wallet`, the artisan has a direct *"Call Customer"* button and *"WhatsApp Chat"* link.
- In `karigaar_partner_job_radar`, the artisan has an action: *"Ask Customer on WhatsApp First"*.

### 6.3 Strategic Options for Contact Disclosure

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                           CONTACT DISCLOSURE TAXONOMY                                   │
├─────────────────────────┬──────────────────────────────┬────────────────────────────────┤
│ OPTION 4A: OPEN DIRECT  │ OPTION 4B: MASKED NUMBERS    │ OPTION 4C: LEAD UNLOCK         │
│ DISCLOSURE              │ (Virtual Cloud Telephony)    │ MONETIZATION                   │
├─────────────────────────┼──────────────────────────────┼────────────────────────────────┤
│ • Full phone visible    │ • Virtual number forwarding  │ • Customer details locked      │
│ • Direct GSM call/wa.me │ • Exotel / Twilio / Kaleyra  │ • Artisan pays ₹50-150 to view │
│ • Disintermediation: 80%│ • Disintermediation: Low-Med │ • Urban Company classic model  │
└─────────────────────────┴──────────────────────────────┴────────────────────────────────┘
```

#### Detailed Comparison:

| Metric | Option 4A: Full Open Contact | Option 4B: Masked Number Gateway (Recommended) | Option 4C: Paid Lead Unlock Model |
|---|---|---|---|
| **Customer Experience** | High immediate convenience; familiarity with direct calling. | **High & Safe**. One-tap click-to-call connects instantly via a secure local virtual landline. | Medium. Customer is bombarded with calls from multiple competing contractors. |
| **Customer Privacy & Safety** | **Severe Hazard**. Homeowner mobile number and address exposed to all artisans. High harassment risk for female homeowners. | **Bank-Grade Safety**. Customer number masked. Number deactivates 2 hours post job completion. | Poor. Lead distributed to 3–5 artisans who call repeatedly. |
| **Platform Disintermediation** | **Critical (70–85% leakage)** after 1st transaction. Zero recurring platform revenue. | **Controlled**. Phone numbers are never revealed; off-platform communication friction remains high. | Moderate. Artisans transact off-platform once the lead is unlocked. |
| **Operational Telephony Cost** | ₹0.00 (Standard GSM direct cellular call). | ₹0.30 – ₹0.50 per call minute via Exotel / Twilio / Knowlarity. | ₹0.00 (Artisan pays cellular carrier). |

### 6.4 The Platform Retention Moat (Why Customers & Artisans Stay)
Even with masked numbers, parties can exchange phone numbers verbally once inside the home. Therefore, **technical masking alone cannot prevent leakage; the platform must provide economic and safety incentives that make off-platform transactions irrational**:

```
                              THE RETENTION MOAT
                                      │
        ┌─────────────────────────────┼─────────────────────────────┐
        ▼                             ▼                             ▼
[CUSTOMER MOAT]               [ARTISAN MOAT]               [TRANSACTION MOAT]
• ₹10k–25k Guild Damage Cover  • 0% Commission Master Tier  • Material Bill Builder
• 30-Day Free Rework Warranty   (Unlocks after 50 jobs)      (18% GST input invoice)
• Vetted Police Background    • Daily instant UPI payouts   • Digital Escrow & OTP
• Transparent Rate Card       • Free tool calibration cover • One-tap dispute hold
```

1. **For the Customer:**
   - **₹10,000 to ₹25,000 Guild Damage Cover** (highlighted on `active_job_live_tracking` and `karigaar_profile_reviews`). If an artisan causes water damage or burns wiring, Karigaar covers the repairs. If booked off-platform, the customer absorbs 100% of the loss.
   - **30-Day Free Rework Warranty**: Free rework dispatch if a fitted valve or MCB fails within 30 days.
   - **Rate Card Protection**: Prevents on-site extortion and arbitrary pricing.
2. **For the Artisan:**
   - **0% Commission Master Tier Progression**: As seen in `partner_active_job_wallet`, after completing 50 jobs with 4.8+ rating, the artisan unlocks the 0% commission tier. Cutting out the platform yields zero financial gain.
   - **Instant Daily IMPS / UPI Payouts**: Zero transaction fees for bank withdrawals.
   - **Steady Demand & Proximity**: Active radar dispatches within 2 km reduce transit fuel costs.
3. **For Both:**
   - **Official GST Invoicing & Material Receipts**: Customers in affluent societies require GST bills for apartment maintenance claims; the app's Material & Labor Bill builder automatically formats this.

### 6.5 Privacy, Compliance & Safety Protections
- **Digital Personal Data Protection (DPDP) Act Compliance:** Customer contact data must not be transferred or sold without explicit purpose-bound consent.
- **Do Not Disturb (DND) Enforcement:** Marketing communications restricted between 9:00 PM and 9:00 AM.
- **Harassment Mitigation:** Masked numbers automatically disconnect and re-route after job closure. Immediate blacklisting trigger if an artisan contacts a customer through private channels.
- **Emergency SOS Protocol:** Dedicated red **"SOS Help"** button on `active_job_live_tracking` triggers immediate admin dashboard alert on `super_admin_portal` and shares real-time location with local emergency contacts.

### 6.6 Founder Decision 4 Summary
- **Open Decision:** Disclose raw mobile numbers, mandate masked virtual telephony, or adopt a paid lead unlock model?
- **Recommended Default:** **Option 4B: Virtual Masked Telephony (via Exotel/Twilio) paired with the Platform Retention Moat**. Raw phone numbers are never rendered in client UI. Enforce the ₹25k warranty and 30-day rework cover as the primary psychological barrier against off-platform leakage.

---

## 7. Decision Area 5: Booking State Machine Rules & Operational SLAs

### 7.1 Comprehensive 14-State Booking Life Cycle
The core business workflow spans 14 discrete states, handling both Path A (Quoted Projects) and Path B (Instant Dispatches):

```
[1. DRAFT] ──► [2. QUOTE_REQUESTED] ──► [3. QUOTES_RECEIVED] ──► [4. QUOTE_ACCEPTED]
     │                                                                   │
     │ (Instant Path B)                                                  ▼
     └────────────────────────────────────────────────────────► [5. DEPOSIT_ESCROWED]
                                                                         │
                                                                         ▼
                                                                [6. ARTISAN_DISPATCHED]
                                                                         │
                                                                         ▼
                                                                [7. ARTISAN_ARRIVED]
                                                                         │ (Start Code Verified)
                                                                         ▼
                                                                 [8. IN_PROGRESS]
                                                                         │
                                        ┌────────────────────────────────┴──────────────────────────────┐
                                        ▼                                                               ▼
                              [9. WORK_COMPLETED]                                                [13. DISPUTED]
                                        │                                                               │
                                        ▼                                                               ▼
                           [10. CUSTOMER_VERIFICATION]                                         [ADMIN ARBITRATION]
                                        │ (OTP Verified)                                                │
                                        ▼                                                               ▼
                              [11. PAYMENT_RELEASED]                                          [REFUND / PAYOUT]
                                        │
                                        ▼
                                  [12. CLOSED]
                                  
* Note: [14. CANCELLED] can be reached from States 1, 2, 3, 4, 5, 6, 7 subject to cancellation rules.
```

### 7.2 State Transition Matrix

| # | State Name | Permitted Actor | Trigger / Event | Preconditions | Next State | Error / Timeout Action |
|---|---|---|---|---|---|---|
| **1** | `DRAFT` | Customer | Customer configures task, uploads photo/voice note. | Client-side session valid. | `QUOTE_REQUESTED` or `DEPOSIT_ESCROWED` | Auto-purged after 24 hrs inactivity. |
| **2** | `QUOTE_REQUESTED` | System | Path A project broadcasted to local guild masters. | Customer submitted project details. | `QUOTES_RECEIVED` | Timeout in 15 mins if 0 responses; trigger wider radius. |
| **3** | `QUOTES_RECEIVED` | Artisan | Artisans submit proposed itemized estimates. | Artisan verified and within radius. | `QUOTE_ACCEPTED` | Quotes expire automatically after 24 hours. |
| **4** | `QUOTE_ACCEPTED` | Customer | Customer selects winning bid. | Minimum 1 valid quote received. | `DEPOSIT_ESCROWED` | Offer void if deposit not placed within 2 hours. |
| **5** | `DEPOSIT_ESCROWED` | Customer / PG | Diagnostic fee (Path B) or Project advance (Path A) authorized. | Payment gateway charge success. | `ARTISAN_DISPATCHED` | If payment fails, revert to `DRAFT` / `QUOTE_ACCEPTED`. |
| **6** | `ARTISAN_DISPATCHED` | Artisan / System | Nearest artisan accepts 45s dispatch prompt on Radar. | Artisan toggled "Online"; deposit held. | `ARTISAN_ARRIVED` | If artisan fails to move in 10 mins, auto-reassign. |
| **7** | `ARTISAN_ARRIVED` | Artisan | Artisan taps "Reached Location" within 200m geofence. | GPS geofence confirms arrival at address. | `IN_PROGRESS` | 15-min arrival grace period before cancellation alert. |
| **8** | `IN_PROGRESS` | Artisan & Customer | Artisan enters customer's 4-digit Security Start Code (`4921`). | Correct 4-digit PIN matching database record. | `WORK_COMPLETED` or `DISPUTED` | Max job execution window: 8 hrs before ops alert. |
| **9** | `WORK_COMPLETED` | Artisan | Artisan submits final bill (diagnostic + spare parts receipt). | Job timer running; bill photos attached. | `CUSTOMER_VERIFICATION` | Customer notified via push + WhatsApp. |
| **10** | `CUSTOMER_VERIFICATION`| Customer | Customer inspects work; enters 4-digit Job Completion OTP. | Work completed; final bill rendered on screen. | `PAYMENT_RELEASED` | Auto-release timer: 48 hrs if no dispute filed. |
| **11** | `PAYMENT_RELEASED` | System / Escrow | Platform releases funds from escrow to Artisan Guild Wallet. | Completion OTP confirmed; payment authorized. | `CLOSED` | Ledger balance credited to artisan account. |
| **12** | `CLOSED` | System | Both parties submit mutual ratings & reviews. | Payment settled; invoice generated. | Final State | CSAT review prompt pushed to WhatsApp. |
| **13** | `DISPUTED` | Customer / Artisan | Either party taps "Raise Dispute" or reports damage/bad work. | Work in progress or verification stage. | `CLOSED` or `CANCELLED` | Handed off to Super Admin arbitration portal. |
| **14** | `CANCELLED` | Customer / Artisan | Cancellation request submitted. | Job not yet completed. | Final State | Cancellation fee matrix applied. |

### 7.3 Operational Timeouts & SLA Benchmarks

```
┌────────────────────────────────────────────────────────────────────────┐
│                        CRITICAL SYSTEM SLAS                            │
├───────────────────────────────────┬────────────────────────────────────┤
│ SLA Metric                        │ Target Parameter                   │
├───────────────────────────────────┼────────────────────────────────────┤
│ Radar Dispatch Countdown Timer    │ 45 Seconds (as seen in UI)         │
│ Path A Custom Bid Response Window │ 15 Minutes                         │
│ Express Arrival Window (Path B)   │ 25 - 45 Minutes                    │
│ Artisan Arrival Grace Period      │ 15 Minutes beyond ETA              │
│ WhatsApp OTP Resend Window        │ 42 - 60 Seconds                    │
│ Uncontested Escrow Release Auto   │ 48 Hours post work completion      │
│ Dispute Mediation Turnaround      │ < 4 Hours                          │
└───────────────────────────────────┴────────────────────────────────────┘
```

### 7.4 Cancellation & Refund Policy Matrix

| Cancellation Trigger | Stage of Cancellation | Financial Consequence to Customer | Compensation to Artisan | Platform Action |
|---|---|---|---|---|
| **Customer Initiated** | Within 3 mins of booking | 100% Full Refund (₹0 fee) | ₹0 | Booking reset; re-entered into pool. |
| **Customer Initiated** | After artisan dispatched (>5 mins) | ₹99 Transit Fee deducted | ₹80 credited to artisan for fuel/time | Platform retains ₹19 processing. |
| **Customer Initiated** | Artisan has arrived at doorstep | Full Visit Fee (₹199 / ₹299) charged | 85% of Visit Fee paid to artisan | Customer receives inspection credit. |
| **Artisan Initiated** | En route (Artisan emergency) | 100% Refund + ₹50 Karigaar Credit | ₹0 | Priority instant re-dispatch; artisan acceptance penalty. |
| **Artisan No-Show** | 15 mins past grace period | 100% Refund + ₹100 apology credit | ₹0 | Artisan suspended from Radar for 24 hrs. |

### 7.5 Dispute Resolution & Escrow Release Architecture
1. **Initiation:** Customer taps "Report Issue" on `active_job_live_tracking` or rejects completion OTP on `partner_active_job_wallet`.
2. **Escrow Freeze:** The backend locks the escrowed funds immediately. No automatic withdrawal to artisan wallet is permitted.
3. **Evidence Submission:** Both customer and artisan have 12 hours to upload before/after photos and spare part receipts via WhatsApp or in-app.
4. **Super Admin Triage:** The case enters the **Guild Dispute Queue** on `super_admin_portal`. An ops mediator reviews the uploaded MCB/pipe photos and decides:
   - *Option A (Resolution):* Release 100% to artisan if work meets guild standard.
   - *Option B (Rework):* Dispatch an NSDC Master Artisan to rectify free of charge under the Karigaar 30-Day Guarantee.
   - *Option C (Customer Refund):* 100% refund to customer + damage compensation claimed under the ₹25k Guild Cover.

### 7.6 Founder Decision 5 Summary
- **Open Decision:** Approve the 14-state life cycle, strict 45s dispatch timeout, customer cancellation fees, and 48-hour auto-release rule?
- **Recommended Default:** **Adopt the 14-state state machine**. Enforce the ₹99 transit cancellation fee once an artisan has travelled >1 km. Automate escrow release 48 hours post completion if the customer remains unresponsive.

---

## 8. Decision Area 6: Core Business, Monetization & Communications Architecture

### 8.1 Artisan KYC & Verification Tiers
The reference materials showcase a clear hierarchy of craftsmanship assurance:
- `home_discovery`: *"100% Police Verified"*, *"Super Artisan"*.
- `karigaar_profile_reviews`: *"Govt. ID & Police Cleared"*, *"NSDC Certified"*, *"₹25,000 Damage Cover"*, *"Calibrated Tools"*.
- `super_admin_portal`: Queue reviews for *"Aadhaar + Police"*, *"NSDC Cert"*, and *"Tool Calibration"*.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        ARTISAN GUILD TIERS                             │
├────────────────────────────────────────────────────────────────────────┤
│ TIER 1: REGISTERED PARTNER                                             │
│ • WhatsApp phone verification                                          │
│ • Front Aadhaar OCR check (HyperVerge / DigiLocker)                    │
│ • Access: Standard broadcast jobs, minor repairs                       │
├────────────────────────────────────────────────────────────────────────┤
│ TIER 2: GUILD VERIFIED PRO (Silver / Gold Guildsman)                   │
│ • Clear criminal background verification (Police / Third-party)        │
│ • Verified settlement bank account (Penny drop IMPS)                   │
│ • Physical/Video tool kit audit (Multimeter, Laser level)              │
│ • Access: Emergency 25-min dispatches, up to ₹1,000 ticket jobs        │
├────────────────────────────────────────────────────────────────────────┤
│ TIER 3: MASTER GUILDSMAN (NSDC Certified)                              │
│ • National Skill Development Corp (NSDC) or ITI trade diploma          │
│ • 50+ completed jobs on platform with 4.85+ average rating            │
│ • Access: High-ticket custom projects, 0% commission master tier       │
└────────────────────────────────────────────────────────────────────────┘
```

### 8.2 Monetization & Revenue Models

```
┌────────────────────────────────────────────────────────────────────────┐
│                      REVENUE STREAM BLUEPRINT                          │
├─────────────────────────┬──────────────────────┬───────────────────────┤
│ Revenue Stream          │ Applicable Flow      │ Unit Economics        │
├─────────────────────────┼──────────────────────┼───────────────────────┤
│ Platform Take-Rate      │ Path B Bookings      │ 10% - 15% of labor    │
│ Platform Safety Fee     │ All Customer Orders  │ Flat ₹29 per booking  │
│ Custom Project Lead Fee │ Path A Major Bids    │ ₹79 - ₹199 per bid    │
│ Instant Payout Fee      │ Partner Withdrawals  │ ₹0 IMPS promotional   │
│ Guild Partner Premium   │ Artisan Subscription │ ₹499/mo (Priority)    │
└─────────────────────────┴──────────────────────┴───────────────────────┘
```

1. **Path B Take-Rate:** 12% commission on labor billing. When an artisan completes a ₹600 repair, the platform retains ₹72, and ₹528 is credited to the artisan.
2. **Platform Safety & Insurance Shield (₹29):** Explicitly itemized on `service_details_custom_quote`. Directly funds the platform's third-party group insurance policy (covering up to ₹25,000 in damages). Highly accepted by consumers as an assurance fee.
3. **Master Guildsman 0% Commission Incentive:** As depicted in `partner_active_job_wallet` (*"Only 8 jobs remaining to unlock 0% commission master tier!"*), top artisans retain 100% of their labor after 50 successful jobs, eliminating disintermediation incentive.

### 8.3 WhatsApp Business API vs SMS Infrastructure & Cost Model
- **UI Evidence:** `login_whatsapp_onboarding`, `whatsapp_otp_verification_modal`, `karigaar_partner_job_radar`, and `super_admin_portal` highlight extensive WhatsApp dependency (*"Bot Active Dual Sync"*, *"Instant OTP Dispatch"*, *"Voice memo available via WhatsApp"*).
- **The Cost Reality (Meta WhatsApp Cloud API Pricing in India):**
  - **Authentication Template:** ~₹0.12 per conversation.
  - **Utility Template (Order updates, dispatch alerts):** ~₹0.35 per conversation.
  - **Service Conversation (Customer-initiated chat window):** Free within 24-hr window.
- **Cost Scaling Analysis:**
  - At 1,000 daily bookings, generating 4 outbound notification templates per job = 4,000 messages = **₹1,400/day (~₹42,000/month)**.
  - Traditional Indian transactional SMS (DLT registered) costs **₹0.11 - ₹0.14 per SMS**, but has a 12-18% failure/delay rate and zero support for audio voice memos or photos.

```
┌────────────────────────────────────────────────────────────────────────┐
│                      HYBRID MESSAGING PIPELINE                         │
├────────────────────────────────────────────────────────────────────────┤
│ Primary Vector: WhatsApp Cloud API                                     │
│ • OTP delivery (Instant 1-tap autofill)                                │
│ • Job Dispatch Card + Photo + Audio Memo stream                        │
│ • Customer live gate PIN & GPS pin delivery                            │
├────────────────────────────────────────────────────────────────────────┤
│ Secondary Fallback: Transactional SMS (DLT Route)                      │
│ • Triggers automatically after 42s if WhatsApp webhook not delivered   │
│ • SMS gateway: Gupshup / Kaleyra / MSG91                               │
│ • Plain-text OTP and critical emergency dispatches                     │
└────────────────────────────────────────────────────────────────────────┘
```

### 8.4 Founder Decision 6 Summary
- **Open Decision:** Confirm verification tiers, commission percentages, and approve the WhatsApp Cloud API + DLT SMS fallback architecture?
- **Recommended Default:** Implement the **3-Tier Verification model**. Charge **12% commission on Path B labor + flat ₹29 customer safety fee**. Implement the **WhatsApp-First hybrid gateway with 42s SMS fallback**.

---

## 9. Consolidated Founder Decision Matrix & Next Steps

| # | Strategic Area | Open Decision Statement | Recommended Default Choice | Implementation Blocking? |
|---|---|---|---|---|
| **D1** | **Pilot City** | Exact pilot municipality and neighborhood bounds. | **Gurugram (Cyber City, DLF Phase 1–5, Sec 42–48 corridor)**. | **YES (Blocks Geofence & Seeds)** |
| **D2** | **Launch Categories** | Scope of trades and minor vs major project boundaries. | **Core 3 Trades (Electrician, Plumber, Carpenter)**; baseline diagnostic fee ₹199–₹299. | **YES (Blocks Taxonomy Schema)** |
| **D3** | **Mobile App Topology**| Single unified app with role switch vs distinct apps. | **Distinct Apps** (Customer & Partner) in a single shared monorepo. | **YES (Blocks App Scaffolding)** |
| **D4** | **Contact Policy** | Phone number disclosure vs virtual masking. | **Masked Virtual Telephony (Exotel/Twilio)** + Platform Moat. | **YES (Blocks Telephony Architecture)** |
| **D5** | **State Machine** | Booking state machine transitions, SLAs & timeouts. | **14-State State Machine** with 45s dispatch timeout & ₹99 transit fee. | **YES (Blocks Backend Engine)** |
| **D6** | **Monetization & Comms**| Commission rates, safety fee, WhatsApp API budget. | **12% Take-rate + ₹29 Safety Fee**; WhatsApp-first messaging. | **YES (Blocks Ledger & Messaging)** |

---
*Report authored by Teamwork Spec Miner (`spec_miner_founder`). All recommendations are grounded directly in the provided reference materials and operational realities of the Indian home services market.*
