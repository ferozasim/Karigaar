# Karigaar Artisan Trust — Phase 0 Master Review & Founder Requirements Baseline

---

## 1. Executive Summary & Strategic Vision

### 1.1 The Market Paradox in Indian Home Services
The residential maintenance and home repair ecosystem in India represents a multi-billion dollar market that remains overwhelmingly informal. Over 85% of transactions for carpenters, electricians, plumbers, masons, and appliance technicians occur through informal channels: neighborhood word-of-mouth, security guard referrals at gated apartment complexes, or roadside hardware store recommendations.

This informal status quo presents a profound structural paradox:
- **The Customer Pain Point**: Homeowners suffer from unpredictable pricing ("inspection extortion"), lack of background vetting (safety anxieties, especially for elderly residents or women living alone), unverified skill levels, and zero accountability when faulty work causes water damage or electrical fires.
- **The Artisan Pain Point**: Skilled blue-collar tradespeople (*Karigaars*) are trapped in informal cycles of wage vulnerability, delayed cash settlements, high customer acquisition friction, and aggressive commission extraction by centralized gig platforms that commoditize craftsmanship into anonymous labor units.
- **The Platform Dilemma**: Incumbent gig-economy platforms have attempted to impose rigid, factory-style standardization on artisanal trades. In doing so, they alienate master craftsmen, experience rampant off-platform disintermediation (leakage to direct cash/UPI), and struggle with high customer churn.

### 1.2 The "Master Guildsman Meets Modern Concierge" Philosophy
**Karigaar** solves this paradox by establishing a digital craft guild. Rather than treating artisans as anonymous gig workers, Karigaar honors their mastery, elevates their social standing, and equips them with institutional trust credentials (Aadhaar KYC, Police background clearance, National Skill Development Corporation [NSDC] certification, and calibrated laser tool audits).

For homeowners, Karigaar delivers modern concierge-grade assurance: instant WhatsApp onboarding, rapid 25-minute emergency dispatches, live GPS telemetry, dual-factor security OTPs (arrival Start Code `4921` + post-service Completion OTP), transparent rate cards with a ₹29 Safety & Insurance Shield, and a ₹25,000 Guild Damage Guarantee with 30-day free rework protection.

### 1.3 Phased Pilot Strategy: Gurugram Launch to Pan-India Guild
To validate liquidity, unit economics, and operational rigor, Karigaar adopts a phased expansion strategy:
1. **Phase 1 Pilot Corridor**: **Gurugram / NCR** (DLF Phase 1–5, Cyber City, Golf Course Road, and the Sector 42–48 corridor). This micro-cluster represents India's highest per-capita concentration of high-income gated condominiums with acute willingness to pay for rapid, verified home services.
2. **Phase 2 Metropolitan Expansion**: Cluster Beta in Sohna Road / Southern Peripheral Road, followed by Bengaluru (Indiranagar, Koramangala, HSR Layout) and Mumbai / MMR (Powai, Thane, Western Suburbs).
3. **Phase 3 Pan-India Guild**: National rollout spanning 25+ Tier-1 and Tier-2 urban hubs, backed by the decentralized Karigaar Guild trust network.

---

## 2. Comprehensive Screen-by-Screen Review (All 12 Reference Screens)

The reference UI assets located in `c:\Users\asimf\Downloads\stitch_karigaar_app_ui\stitch_karigaar_app_ui` define the end-to-end frontend experience. Below is an exhaustive technical review of all 12 core screens, documenting their target persona, shell structure, layout hierarchy, interactive components, micro-interactions, trust mechanisms, and data schemas.

---

### Screen 1: Home Discovery (`home_discovery`)
- **Target Persona**: Homeowner / Residential Tenant (Customer).
- **Shell Type**: `mobile_tab` (Fixed header, vertically scrolling content canvas, sticky frosted 4-tab bottom navigation).
- **Viewport Baseline**: 390px (mobile-first responsive, optimized for iOS/Android flagships).

#### Layout Hierarchy & Key Components
1. **Header Bar**:
   - Left: Karigaar squircle mark (32px), title "Karigaar Explore", and interactive Location Selector dropdown (*"Home • 42 Green Valley, Sector 4"* with chevron).
   - Right: Notification Bell with unread amber indicator dot (`bg-secondary`) and customer profile thumbnail avatar.
2. **Search & Action Bar**:
   - Elevated full-width search container (48px height, rounded-xl, `#FFFFFF` surface) with placeholder text: *"Search electricians, carpenters, plumbers..."*.
   - Inline action buttons: Artisan Amber voice search microphone (`mic`, `#D97706`) and filter tuning icon button (`tune`).
3. **Emergency Quick-Assist 24x7 Banner**:
   - High-contrast gradient card (`from-secondary via-secondary-container to-amber-600`) featuring an animated pulsing green live beacon (`animate-ping`).
   - Copy: *"Urgent Breakdown? Get an artisan dispatched to your doorstep within 25 mins."*
   - CTA: *"Book Fast"* (bolt icon with scale-95 micro-interaction on tap).
4. **Artisan Guilds 8-Grid Taxonomy**:
   - 4-column x 2-row category grid with pastel tinted squircle containers (48px) and trade icons:
     1. Electrician (Amber tint, bolt)
     2. Carpenter (Orange tint, carpenter saw)
     3. Plumber (Blue tint, plumbing tap)
     4. Painter (Purple tint, format_paint)
     5. Appliance (Cyan tint, mode_fan)
     6. Masonry (Stone tint, foundation)
     7. Pest Guard (Emerald tint, pest_control)
     8. Locksmith (Amber-warm tint, lock_reset)
   - Header control displays category counter link: *"Artisan Guilds — All (14)"*.
5. **The Karigaar Shield Commitment Banner**:
   - 3-pillar horizontal trust banner:
     - *100% Police Verified* (Aadhaar & criminal background vetting)
     - *Rate Card Protection* (Zero hidden surprises or on-site extortion)
     - *30-Day Guarantee* (Free rework cover)
6. **Top Rated Karigaars Nearby Stack (Sector 4)**:
   - Header with green pulsing live dispatch beacon.
   - **Craftsman Card 1**: *Rajesh Sharma* — Master Carpenter, 8 yrs exp, 1.4 km away, 4.9★ (320 reviews), "Police Verified" emerald pill, "Super Artisan" badge, quote: *“Specialist in modular kitchen fittings, veneer repairs & high-security door locks.”*, Inspection fee `₹299` ("adjustable in bill"), CTA *"Hire Artisan"*.
   - **Craftsman Card 2**: *Tariq Anwar* — Certified Electrician, 12 yrs exp, 2.1 km away, 4.8★ (410 reviews), "Police Verified", "Heavy Power Expert", quote: *“Inverter wiring, MCB recurring tripping, chandelier setup & smart switches.”*, Inspection fee `₹199` ("adjustable in bill"), CTA *"Hire Artisan"*.
7. **Curated Guild Packages (Seasonal Bundles)**:
   - AC Deep Service & Jet Clean (Summer Prep Bundle, 20% OFF tag, ₹599 slashed from ₹749, "Add +" CTA).
   - Full Home Electrical Audit (Safety First, POPULAR tag, 32-point earthing and surge test, ₹799 slashed from ₹999, "Add +" CTA).
8. **Interactive Custom Quote Teaser**:
   - Handshake card: *"Need a custom estimation? Post your requirement & receive bids from verified masters within 15 mins."* with CTA *"Post Job"*.
9. **Fixed Bottom Navigation Bar**:
   - 4 tabs: Explore (Active, Deep Slate), Bookings, Messages (with unread badge counter '2'), Profile.

#### Interactive States & Data Models
- **Search Focus**: Elevates card elevation from Level 1 to Level 2 with amber outline highlight.
- **Card Taps**: 95% scale active down-state.
- **Data Model**: `CustomerHomeFeed` (userLocation, emergencyActive, tradeCategories[], featuredArtisans[], seasonalPackages[]).

---

### Screen 2: Service Details & Custom Quote (`service_details_custom_quote`)
- **Target Persona**: Customer (Homeowner configuring a repair package).
- **Shell Type**: `mobile_stack` (Top navigation with back arrow, title "Booking Flow", profile avatar, sticky bottom checkout dock).

#### Layout Hierarchy & Key Components
1. **Service Hero & Trust Header**:
   - Deep slate container (`bg-primary-container`), verified badge pill (*"Verified Master Electrician"*), rating *4.9 (1.2k)*.
   - Title: *"Electrical Repair & Wiring"*.
   - Subtitle: *"Safety-first resolution with certified equipment and calibrated multi-meters."*
   - Embedded warranty banner: *"Standard visit includes comprehensive 45-min diagnostic inspection & 30-day rework warranty."*
2. **Interactive Issue Selector (Multi-Option Package Builder)**:
   - Task Card 1: *Short Circuit / MCB Tripping* (Continuous tripping, spark identification & fuse check) — `₹249 Estimated` (Default active, primary checkmark).
   - Task Card 2: *Switchboard / Socket Repair* (Loose modular switches, burnt contact points) — `₹149 Starting`.
   - Task Card 3: *Ceiling Fan / Chandelier Fitting* (Anchor rod hanging, speed regulator rewiring) — `₹199 Per unit`.
   - Task Card 4: *Inverter & Battery Wiring* (Backup bypass, heavy load terminal setup) — `₹399 Complete`.
   - Dynamic math: Tapping toggles selection and updates checkout total in real time.
3. **Upload Issue Visual & Audio Voice Memo**:
   - Thumbnail preview of uploaded electrical panel (`main_mcb_panel.jpg` with remove "X" button) + "Add photo" dropzone.
   - Helper microcopy: *"Helps your Karigaar pack compatible switches, testers, and correct amp fuses."*
   - Audio recorder: *"Add 15s voice note for Karigaar"* with *"Record"* button.
4. **Preferred Schedule Slot Carousel**:
   - Horizontal date carousel: *Fastest: Today, 45m* (Default active, primary slate) | *Tomorrow: Oct 14* | *Wednesday: Oct 15* | *Thursday: Oct 16*.
   - Time slot vertical stack: Morning (*09:00 AM – 11:00 AM*), Afternoon (*02:00 PM – 04:00 PM*, Popular tag), Evening (*05:00 PM – 07:00 PM*).
5. **Price Transparency Breakdown**:
   - Standard Diagnostic & Visit: `₹199`
   - Configured Issue / Task: `₹249`
   - Karigaar Safety & Insurance Shield: `₹29`
   - Total Guaranteed Estimate: `₹477` (*"Final bill adjusted only if new hardware required"*)
   - Escrow pledge: *"No advance needed. Inspect work before releasing OTP payment."*
6. **Sticky Frosted Bottom Checkout Dock**:
   - Left: `₹477 all incl.` + `45m estimate` timer icon.
   - Right: Amber CTA *"Select Karigaar"* with right arrow.
   - Tapping triggers loading spinner state (*"Finding Karigaars..."*) followed after 1200ms by matched state (*"3 Matched!"* in emerald).

---

### Screen 3: Active Job Live Tracking (`active_job_live_tracking`)
- **Target Persona**: Customer (Homeowner tracking assigned artisan en route and during work).
- **Shell Type**: `mobile_stack` (Top utility bar with SOS, map viewport, scrolling status card).

#### Layout Hierarchy & Key Components
1. **Top Utility Bar**:
   - Pulsing emerald live beacon + Job `#KG-8842` + Category pill *"Woodwork"*.
   - Action buttons: Red *"SOS Help"* button (`bg-error-container`) and *"Minimize Map"* toggle.
2. **Live Map Canvas (Height 288px)**:
   - Geospatial street map centered on Gurugram Sector 48 / 42 Green Valley.
   - Multi-segment SVG route polyline:
     - Completed sub-segment in Verified Emerald (`#069669`).
     - Active route polyline in Artisan Amber (`#FE932C`).
     - Planned route glow path in Deep Slate (`#131B2E`).
   - Bouncing Destination Pin at customer home (*"42 Green Valley"*).
   - Moving Artisan Motorcycle Marker (`two_wheeler` icon) with double pulsing radar wave and real-time floating ETA pill: *"ETA 14 min (1.8 km)"*.
   - Floating controls: Re-center on Karigaar (`near_me`), Toggle Traffic layer (`traffic`).
3. **Real-Time Job Status Card**:
   - Headline: *"Artisan On The Way"* (Arriving by 02:35 PM • 14 mins remaining • "On Time" chip).
   - 5-Step Segmented Milestone Progress Track:
     1. Booking Confirmed (02:10 PM) — [Completed / Checkmark]
     2. Karigaar Dispatched (02:18 PM) — [Completed / Checkmark]
     3. On the Way (Passing Cyber Hub) — [Active / Spinning sync icon]
     4. Job Execution — [Pending OTP release]
     5. Quality Sign-off — [Estimated 03:45 PM]
4. **Assigned Karigaar Profile Module**:
   - Avatar squircle with verified badge: Rajesh Kumar, Master Carpenter, 11+ yrs exp, Guild Pro, 4.9★ (418 jobs).
   - **Security Start Code Box**:
     - Label: *"Security Start Code — Share only after Rajesh arrives"*
     - Large numeric PIN block: **`4921`** (4-digit security token required to start job).
   - Direct contact buttons: *"Call Artisan"* (`tel:+919876543210`) & *"Send Message"* (opens modal drawer).
   - Canned communication quick-chips (horizontal scroll):
     - `📍 Gate code is 8842`
     - `🅿️ Visitor parking spot #4`
     - `🔔 Ring the doorbell twice`
5. **Karigaar Guild Protection Active Banner**:
   - Shield badge: *"Includes ₹10,000 damage cover, background-verified technician, & contactless OTP lock."*
6. **Job Scope & Order Breakdown (Expandable Accordion)**:
   - Door Hinge & Alignment Repair (2 doors): `₹599`
   - Custom Wooden Shelf Latch Fix: `₹249`
   - Dispatched Tool Kit & Guild Fee: `FREE`
   - Total Estimation: `₹848` (*"Pay after full inspection"*)
7. **Safety Actions Footer**:
   - Full-width button: *"Share Live Tracking with Family"*.
   - Footer links: *"Need to Reschedule?"* | *"Cancel Booking"* (in error red).
8. **Interactive Quick Messaging Modal Drawer**:
   - Pull-up sheet: *"Direct Chat with Rajesh — Online & Riding"*.
   - Verbatim dialogue:
     - Artisan: *"Namaste Ji, I have collected the required precision drill bits. I will reach in about 14 minutes."*
     - Homeowner: *"Sure Rajesh! Gate security has already been notified of your vehicle."*
   - Input field with send button.

---

### Screen 4: Create Account & Artisan Registration (`create_account_artisan_registration`)
- **Target Persona**: Artisan / Tradesperson (Partner Onboarding Step 1 of 3).
- **Shell Type**: `mobile_stack` (Step indicator header, scrollable registration form, sticky bottom action bar).

#### Layout Hierarchy & Key Components
1. **Onboarding Sub-Header & Step Indicator**:
   - Sub-bar: Step 1 indicator circle + text *"Step 1 of 3: Profile & Trade"*.
   - Dual Language Toggle Pill: `English` | `हिंदी` (bilingual toggle for trade terminology).
   - Animated progress bar: 33.3% filled.
2. **Guild Welcome & Earning Proposition Card**:
   - Deep slate container: *"Join the Karigaar Guild"*.
   - Badges: *"Guild Accreditation"* & *"0% Commission Offer"*.
   - Value proposition: *"Connect directly with premium households in your pin code. Transparent daily payouts and guild master insurance cover."*
   - Earnings trust strip: *"Over ₹42,000/mo Avg. Earnings — Join 12,400+ verified professionals across NCR & MMR"*.
3. **Role Switcher Segmented Control**:
   - Segmented toggle: *"I am a Karigaar"* (Active, handyman icon, amber dot) vs *"I am a Customer"* (roofing icon).
4. **Primary Trade Selection 2-Column Grid**:
   - 6 selectable trade cards with icons and checkmarks:
     - *Electrician* (Wiring & Inverters) — Default selected with checkmark
     - *Carpenter* (Modular & Woodwork)
     - *Plumbing* (Fittings & Pressure)
     - *AC & Repair* (HVAC & Whitegoods)
     - *Painter* (Textures & Polish)
     - *Masonry* (Tiles, Granite & Civil)
5. **Artisan Legal Identity Form**:
   - Full Legal Name input: *"Matches Aadhaar Card"* (Default: Ramesh Chandra Sharma).
   - WhatsApp Mobile Number: `+91` country code, verified green checkmark badge, sub-pill: *"Instant OTP Dispatch"*.
   - Primary Working Locality: Dropdown selector (Default: *"Sector 48, Sohna Road, Gurugram"*).
   - Trade Experience Pill Selector (4 choices):
     - `1 - 3 Years`
     - `3 - 5 Years` (Default selected)
     - `5 - 10 Years`
     - `10+ Master` (With military medal icon)
     - Helper note: *"Higher tier gets priority leads"*.
6. **Aadhaar / Trade Card Upload Card & Dropzone**:
   - Header: *"Aadhaar / Trade Card — Front photo or DigiLocker sync"* (Marked "Encrypted").
   - Dropzone with camera icon: *"Capture Front of Aadhaar Card — Clear photo • Max size 10MB (JPG/PNG)"*.
   - Live simulated progress bar (72% filled): `aadhaar_front_scan.jpg` — *"72% Auto-verified"*.
7. **WhatsApp Dispatch Dispatcher Opt-In Checkbox**:
   - Checked by default: *"Receive emergency high-pay calls, daily settlement slips, and guild warranty alerts instantly."*
8. **Master Craftsman Referral Code Accordion**:
   - Expandable details element: *"Have a Master Craftsman Referral Code?"* with input (placeholder `GUILD500`) and *"Apply"* button.
9. **Sticky Bottom CTA Bar**:
   - Primary action: *"Verify via WhatsApp OTP"* (Secondary amber container, lock icon, arrow).
   - Microcopy link: *"Already registered in the Guild? Log In here"*.

---

### Screen 5: Login & WhatsApp Onboarding (`login_whatsapp_onboarding`)
- **Target Persona**: Shared Authentication Gateway (Homeowner and Artisan Partner).
- **Shell Type**: `mobile_auth` (Full-height responsive auth container).

#### Layout Hierarchy & Key Components
1. **Header Bar**:
   - Karigaar squircle logo + title "Karigaar".
   - Language selector pill: `translate` icon + *"EN / HI"*.
   - Profile thumbnail placeholder.
2. **Warm Artisanal Greeting Banner**:
   - Badge: *"Guild Certified Safe"* (secondary amber with verified checkmark).
   - Main heading: *"Welcome to Karigaar"*.
   - Bilingual Hindi tagline: **"भारत के सबसे भरोसेमंद कारीगर"** (*India's Most Trusted Artisans*).
   - Subtext: *"Book verified master tradespeople or get hired for high-ticket local jobs."*
   - Imagery: Tactile craftsmanship photograph of artisan hands polishing teak wood with brass tools.
3. **Role Switcher Segmented Tabs**:
   - Tab 1: **Homeowner** (*"Hire an Expert"*, home repair service icon).
   - Tab 2: **Karigaar** (*"Work & Earn"*, handyman icon).
   - Interactive behavior: Switching tabs toggles dynamic promotional content and routes between consumer discovery and partner onboarding.
4. **Dynamic Artisan Benefit Banner (Toggled when Karigaar tab selected)**:
   - Header: *"New Artisan? Register in 2 mins"* + *"0% Commission Month"* badge.
   - Copy: *"Select your craft to start getting instant nearby home bookings directly on WhatsApp:"*
   - Horizontal trade list: Electrician, Carpenter, Plumber, Painter, AC Tech.
   - Trust checklist: `Aadhaar KYC` (id_card icon) | `Tool Insurance` (shield icon) | `Daily Payouts` (currency_rupee icon).
5. **Main Authentication Action Container**:
   - **Primary Action (1-Tap WhatsApp Login)**:
     - Massive button (56px min-height) in Official WhatsApp Emerald Green (`#069669` / `bg-on-tertiary-container`).
     - WhatsApp pure-white SVG vector icon.
     - Title: *"Instant Login with WhatsApp"*.
     - Subtitle: *"1-Tap instant OTP & updates on +91 WhatsApp"*.
   - Divider: *"or continue with mobile number"*.
   - **Mobile Number Entry Form**:
     - Label: *"Mobile Phone Number"* with sub-label *"SMS verification fallback"*.
     - 🇮🇳 +91 country chip with Indian flag and chevron.
     - 10-digit telephone input (`inputmode="numeric"`, `font-numeric-price`).
     - Submit CTA: *"Get Verification Code"* (lock icon; dynamically activates to amber `bg-secondary-container` when 10 digits are typed).
   - Consent microcopy: *"By continuing, you agree to Karigaar Guild's Terms of Service & Privacy Code."*
6. **Craft Guild Trust Strip (3-Column)**:
   - *256-bit Encrypted* — Bank-Grade Privacy
   - *NSDC Partner* — Skill Verified Guild
   - *Guaranteed Rate* — Zero Hidden Charges
7. **Human Concierge Support Touchpoint**:
   - Support agent avatar: *"Need help getting started? Chat with Guild Concierge on WhatsApp"*.
   - Button: *"Chat Now"* (direct WhatsApp link to `https://wa.me/919999999999`).

---

### Screen 6: WhatsApp OTP Verification Modal (`whatsapp_otp_verification_modal`)
- **Target Persona**: Shared Auth (Customer or Artisan completing 2-factor authentication).
- **Shell Type**: `mobile_auth` Modal Sheet / Bottom Sheet Overlay.

#### Layout Hierarchy & Key Components
1. **Modal Architecture**:
   - Semi-transparent backdrop (`bg-black/60 backdrop-blur-sm`).
   - Bottom sheet on mobile (`rounded-t-3xl`), centered dialog on desktop/tablet (`sm:rounded-3xl`).
   - Mobile pull handle indicator (40px wide pill).
2. **Modal Header**:
   - WhatsApp icon badge (`#25D366` green container).
   - Pill: *"Guild Instant WhatsApp Auth"* with lock icon.
   - Title: *"Verify WhatsApp Number"*.
   - Close circular button (`close` icon).
3. **Phone Context & Edit Action**:
   - Recipient number display: *"Code sent to +91 98104 22910"*.
   - Right action: *"Edit Number"* (dismisses modal and returns focus to phone input).
4. **6-Digit OTP Interactive Input Matrix**:
   - 6 individual numeric boxes (48px–56px wide x 56px–64px high, `font-numeric-price`, bold).
   - Keyboard navigation engine:
     - Auto-advances focus to next box upon single digit input.
     - Backspace clears and retreats focus to previous box.
     - Left and Right arrow key navigation supported.
     - Clipboard paste handler automatically strips hyphens and distributes 6 digits across boxes.
   - Microcopy: *"Auto-detecting WhatsApp code..."*.
5. **Countdown Timer & Fallback Communication Channels**:
   - Resend timer: *"Resend code in 00:42"* ticking down to `00:00`.
   - *"Resend OTP"* button (disabled with muted styling until countdown reaches zero, then activates to amber).
   - SMS Fallback: *"Didn't receive code on WhatsApp? Send via SMS"* (triggers secondary SMS gateway dispatch).
6. **Primary Verification CTA**:
   - Full-width button: *"Verify & Continue"*.
   - Dynamic states:
     - Incomplete: Neutral slate (`bg-primary`).
     - Fully filled (all 6 digits): Amber container (`bg-secondary-container`).
     - Submitted: Shows spinner with text *"Verifying Guild Access..."*.
     - Success: Shows checkmark with text *"Authenticated!"* before dismissing modal.
7. **Security Trust Stamp**:
   - Verified shield: *"End-to-end encrypted • Karigaar Guild Secure Auth"*.

---

### Screen 7: Karigaar Partner Job Radar (`karigaar_partner_job_radar`)
- **Target Persona**: Artisan / Tradesperson ("Karigaar Partner").
- **Shell Type**: `karigaar_partner_tab` (Radar, My Jobs, Wallet, Guild bottom tabs).

#### Layout Hierarchy & Key Components
1. **Partner Header Bar**:
   - Karigaar logo + screen title *"Job Radar"*.
   - Duty badge: Pulsing green live beacon + *"ONLINE"*.
   - Notification bell + Artisan profile photo thumbnail.
2. **Status & Geo-Zone Strip**:
   - Live Dispatch beacon: *"Live Dispatch — Gurugram Sector 4 & 5 Zone"*.
   - Quick Duty Toggle Button: Toggle between *"Active"* (high-contrast surface) and *"Paused"* (red error container with power icon).
3. **Today's Metric Bento Strip (3 Pods)**:
   - Pod 1: *Today's Earnings* — `₹1,850` (+`₹420 bonus`).
   - Pod 2: *Completed Jobs* — `3 jobs` (Avg 34 min).
   - Pod 3: *Acceptance Rate* — `98%` (*Master Tier* tag).
4. **WhatsApp Dual Sync Callout**:
   - Container banner with chat icon: *"Bot Active — Dual Sync: Customer voice notes, gate pass PINs, and exact GPS pins stream live to your WhatsApp."*
5. **High-Urgency Incoming Dispatch Card (The Dispatch Radar Alert)**:
   - Emergency banner tag: *"EMERGENCY DISPATCH — MCB / Sparks"*.
   - **Animated Circular SVG Countdown Timer**:
     - Circular progress ring draining from 100% to 0% over **45 seconds**.
     - Dynamic countdown text: `45s`, `44s`, ... down to `0s`.
     - Expiration behavior: If unaccepted, card fades to 40% opacity, pointer events are disabled, and label flips to *"Expired"*.
   - Job details:
     - Title: *"Emergency Short Circuit & MCB Trip"*.
     - Customer: Vikram Mehta • Sector 42 Green Valley (1.8 km away • 8 mins reach time).
     - Payout: `₹480` guaranteed (+ parts reimbursement).
   - Attached Customer Media:
     - Real photo of tripped Havells MCB breaker panel with spark soot mark.
     - Audio note indicator: *"14s Voice memo available via WhatsApp"*.
     - Customer note quote: *"Kitchen lights sparking near oven line, tripped whole sub-circuit. Urgent help!"*
   - Direct WhatsApp Contact Option:
     - Button: *"Ask Customer on WhatsApp First"* (opens pre-filled `wa.me` message: *"Hello Vikram, I am your Karigaar Master Electrician reviewing your MCB emergency."*).
   - Decision Actions:
     - *"Pass"* (Closes and removes card with scale/fade transition).
     - *"Accept Dispatch (45s)"* (Amber CTA; on tap switches to *"Dispatch Confirmed! Opening GPS..."* then *"Navigating to Sector 42..."*).
6. **Nearby Job Radar Broadcast Feed**:
   - Header: *"Nearby Job Radar — 5 Available"*.
   - Filter pills: `All Trades` (Active) | `High Payout (₹500+)` | `Under 3 km` | `Emergency Express`.
   - **Broadcast Card 1 (Carpenter)**:
     - *Modular Kitchen Drawer Channel Repair* (DLF Phase 4 • 2.4 km).
     - Payout: `₹650` (Est. 45 min).
     - Trust tag: *"Pre-inspected by Guild"*.
     - CTAs: *"View"* | *"Claim Job"* (on tap locks to *"Locked & Assigned"* in emerald).
   - **Broadcast Card 2 (Electrician)**:
     - *Ceiling Fan Regulator & 2 Switch Replacements* (Sushant Lok 1 • 3.1 km).
     - Payout: `₹320` (Est. 25 min).
     - Schedule: *"Slot: Today 4:30 PM"*.
     - CTAs: *"View"* | *"Claim Job"*.
   - **Broadcast Card 3 (Plumber)**:
     - *Angle Valve Leakage in Master Bathroom* (South City 2 • 1.2 km).
     - Payout: `₹390` (Est. 20 min).
     - Trust tag: *"Instant Payout Guaranteed"*.
     - CTAs: *"View"* | *"Claim Job"*.
7. **Partner Guarantee Footnote**:
   - *"Partner Guarantee: Up to ₹10,000 tool accidental coverage active"*.
8. **Fixed Bottom Tab Navigation**:
   - Radar (Active, Amber `#D97706`) | My Jobs | Wallet | Guild.

---

### Screen 8: Partner Active Job & Wallet (`partner_active_job_wallet`)
- **Target Persona**: Artisan / Tradesperson executing active work & managing wallet earnings.
- **Shell Type**: `karigaar_partner_tab` (My Jobs tab active in bottom nav).

#### Layout Hierarchy & Key Components
1. **Active Job Execution Card (#KG-8842)**:
   - Header: Pulsing amber indicator + *"Job #KG-8842 • In Progress"*.
   - Live elapsed job timer: Active ticking digital clock (e.g. `28m 14s`).
   - Customer Summary:
     - Pooja Sharma (*Verified* emerald badge).
     - Flat 402, DLF Phase 4, Gurugram.
     - Direct turn-by-turn Navigation button (`directions`).
   - Communication connectors:
     - *"Call Customer"* (`tel:+919876543210`)
     - *"WhatsApp Chat"* (`https://wa.me`)
2. **Material & Labor Bill Builder (Dynamic On-Site Invoicing)**:
   - Base charge: Diagnostic & Labor Fee — `₹249`.
   - Spare part itemization: *Schneider 32A MCB* — `+₹380` (Bill uploaded tag, Qty 1, remove button).
   - Action button: *"Add Spare Part & Attach Invoice"* (with camera icon for receipts).
   - Total customer payable tally: `₹629` (*"Includes 18% GST invoice"*).
3. **Job Completion OTP Security Panel**:
   - Header: *"Job Completion OTP — Ask resident"*.
   - 4-digit numeric input boxes with auto-tab and backspace behavior.
   - Primary completion CTA: *"Verify & Collect ₹629"* (task_alt icon).
4. **Guild Tier Progress Card**:
   - Status: *Gold Guildsman* (Tier Level 4 Craftsman, "Top 5% Partner").
   - Milestone progress gauge: *42 / 50 Jobs completed* (84% progress bar).
   - Incentive microcopy: *"Only 8 jobs remaining to unlock 0% commission master tier!"*
5. **Guild Wallet & Instant Payout Overview**:
   - Header: *"Guild Wallet — Instant IMPS Live"*.
   - Balance Hero Card (Deep slate container):
     - Cleared Available Payout: `₹4,620.00`
     - Pending clearance: `+₹629 pending`
   - Withdrawal Actions:
     - Primary button: *"Withdraw to Bank via UPI / IMPS (₹0 Fee)"* (Instant settlement).
     - Secondary button: *"Send Weekly Earnings Summary to WhatsApp"*.
   - Linked bank account display: *HDFC Bank •••• 2104* (*"Verified Guild Vault"*).
6. **Recent Activity / Ledger Feed**:
   - Transaction 1: *MCB & Wiring Repair* — `+₹480.00 Credited` (Sector 42, Today 11:20 AM).
   - Transaction 2: *Daily Payout to HDFC* — `-₹2,100.00 Success` (Ref #IMPS99824, Yesterday).
   - Policy assurance: *"Guild guarantee: Guaranteed immediate IMPS payout processing 24/7 with zero service deduction."*

---

### Screen 9: Karigaar Profile & Reviews (`karigaar_profile_reviews`)
- **Target Persona**: Customer evaluating an artisan / Public Master Profile.
- **Shell Type**: `mobile_stack` (Top navigation, scrolling profile canvas, sticky bottom booking dock).

#### Layout Hierarchy & Key Components
1. **Profile Hero Header**:
   - Favorite bookmark toggle (heart icon, toggles red fill) + Share button.
   - Avatar presentation: Squircle container with dual-gradient amber frame, verified shield badge (*"PRO"*).
   - Master Craftsman Identity: **Rajesh Kumar Sharma**
   - Trade specialization: *Master Carpenter & Woodcraft Specialist*.
   - Proximity & Availability: *"Indiranagar • Within 4.2 km • Available Today"* (pulsing live green dot).
   - Metric Trio:
     - Rating: **4.95** (418 Reviews)
     - Experience: **11+ Yrs**
     - Volume: **1,240+ Completed Jobs**
2. **Karigaar Verified Guildsman Shield (Triple-Screened Assurance)**:
   - 4 credential pods:
     1. *Govt. ID & Police*: Background Cleared
     2. *NSDC Certified*: Grade-A Woodcraft
     3. *₹25,000 Cover*: Damage Protection
     4. *Calibrated Tools*: Laser-level Verified
3. **Specializations & Certified Skills**:
   - 6 Certified Skill Chips: *Modular Kitchens, Antique Restoration, Concealed Hinges, Teak Wood Polish, Custom Wardrobes, Biometric Lock Fit*.
4. **Past Work Portfolio Showcase (Craftsmanship Gallery)**:
   - Bleeding horizontal carousel with *"View All (38)"* link.
   - Item 1: *Custom Fluted TV Console* (Oak wood, Koramangala 4th Block, "Completed in 2 Days").
   - Item 2: *Vintage Teak Dining Table* (60-year-old Burmese teak restoration, HSR Layout Sector 2).
   - Item 3: *Soft-Close Wardrobe Suite* (Champagne gold profile handles, Indiranagar 100ft Rd).
5. **Artisan Performance Scorecard**:
   - Punctuality & Timing: `5.0 / 5.0` (100% bar)
   - Master Craftsmanship: `4.9 / 5.0` (98% bar)
   - Sawdust & Cleanliness: `5.0 / 5.0` (100% bar) — *Dedicated metric addressing post-service cleanup friction*.
6. **Recent Client Feedback & Verified Reviews**:
   - Review 1: Pooja M. (Defense Colony, 5 stars, *"Verified Main Door Repair Job"*) — Arrived in 20 mins with laser toolkit, fixed jamming Burma teak door, super polite, cleaned sawdust before leaving.
   - Review 2: Amit V. (HAL 2nd Stage, 5 stars, *"Verified Modular Kitchen Fitting"*) — Replaced 6 drawer channels with soft-close Blum fittings, transparent billing.
7. **Sticky Bottom Concierge Action Dock**:
   - Left: `₹299 / visit` + *"Includes ₹25k Guild Warranty"*.
   - Right: Full CTA *"Book Rajesh Now"* (taps transition to *"Securing Slot..."* -> *"Slot Reserved!"* in emerald).

---

### Screen 10: Super Admin Operations Portal (`super_admin_portal`)
- **Target Persona**: Super Admin / Platform Operator (HQ Operations).
- **Shell Type**: `super_admin_mobile` (Mobile-optimized executive operations dashboard).

#### Layout Hierarchy & Key Components
1. **Admin Header Bar**:
   - Karigaar logo + *"Admin Guild"* shield + *"Live 99.8%"* uptime indicator.
   - Global Search, Notification bell with unread amber dot, Admin avatar.
2. **HQ Live Operations Pulse Stream**:
   - Synced live indicator (*"Synced 8s ago"*).
   - Horizontal scrolling operational metrics:
     - *Active Dispatches*: **142**
     - *Available Artisans*: **89**
     - *Dispute Rate*: **0.2%**
3. **2x2 Executive KPI Bento Grid**:
   - *Daily GMV*: `₹1,84,500` (+14% vs yesterday)
   - *Completed*: `328 jobs` (Peak: 11am-2pm)
   - *Guild Queue*: `18 pending` (5 Priority SLA)
   - *WA Outbound*: `1,420 messages` (99.1% delivery rate)
4. **Live Dispatch Radar & Surge Heatmap Widget**:
   - Surge alert banner: *"Surge Grid Alert — High demand in DLF Phase 4 & Cyber City"* (**Surge 1.4x**).
   - Live demand deficit: *"6 Electricians Urgently Needed — Avg ETA stretched to 34 mins"* + *"Route"* button.
   - Background radar concentric circle graphic overlay.
5. **Job Volume Mix by Trade Craft (Category Segmentation)**:
   - Multi-segmented color-coded progress bar:
     - Electrician: **38%** (Secondary container amber)
     - Carpenter: **26%** (Primary container slate)
     - Plumber: **20%** (Tertiary emerald)
     - Appliance: **16%** (Surface tint)
6. **Priority Guild Verification Queue (Artisan KYC Approvals)**:
   - Queue counter: `18 pending`.
   - **Candidate 1 (Ready for signoff)**: Mohd. Salim, Master Plumber & Pipe Fitter, 8 yrs exp.
     - Tags: `Aadhaar + Police` (verified), `NSDC Cert`.
     - Action buttons: *"Approve Guild"* (optimistic approval state) | *"Reject"* (decline state).
   - **Candidate 2 (Incomplete verification)**: Ramesh Verma, AC & Heating Technician, 4 yrs exp.
     - Flag: `Tool Calibration Due` (in red warning container).
     - Action button: *"Review Documents & Tools"*.
7. **WhatsApp Dispatcher & Broadcast Operations**:
   - Status: *API Healthy*.
   - **Emergency Surge Broadcast Tool**:
     - Event: *"DLF 4 Electrician Emergency (Radius 5.5km)"*.
     - Target: *"Notify 24 standby certified technicians with ₹250 bonus surcharge."*
     - Action CTA: *"Broadcast Surge Alert via WhatsApp"* (triggers spinning broadcast state -> *"Broadcast Sent to 24 Artisans"*).
   - **Automated Post-Job CSAT Monitor**:
     - Metric: *94% 5-Star across 1,180 automated WhatsApp feedback responses*.
8. **Fixed Bottom Navigation Bar**:
   - Overview (Active, Amber) | Queue | Dispatches | Config.

---

### Screen 11: Skeleton Loading & Radar Sync (`skeleton_loading_radar_sync`)
- **Target Persona**: Shared Loading State (Customer or Partner waiting for GPS sync, search query, or radar dispatch).
- **Shell Type**: `mobile_stack` skeleton view.

#### Layout Hierarchy & Animation Engine
1. **Custom Shimmer & Pulse Animation Engine**:
   - `@keyframes karigaarShimmer`: 1.8s infinite horizontal sweep (`translateX(-100%)` to `translateX(100%)`) with soft linear gradient (`rgba(255, 255, 255, 0.75)` over `#E5EEFF` container mask).
   - `@keyframes radarSweep`: 2.2s scale-up from 0.7 to 2.4 with opacity fade from 0.9 to 0.
   - `@keyframes softPulseWave`: 0.45 to 0.85 opacity pulse.
   - Staggered animation delay script: `el.style.animationDelay = (index % 5) * 0.18s` preventing visual blockiness.
2. **Skeleton Structural Components**:
   - Top search pill placeholder with search icon mask and dual text line shimmers.
   - Emergency / Radar banner skeleton with animated concentric radar pulse sensor rings (`radar-ping`).
   - 8-Grid category skeleton with trade icon silhouettes (carpenter, plumbing, electrical_services, format_paint, construction, hvac, roofing, handyman).
   - Two nearby craftsman cards skeletons:
     - 56x56px squircle avatar placeholder with verified badge outline.
     - Multi-line name, category, and star rating placeholders.
     - Bottom distance pill and action button rounded placeholders.
3. **Sticky Telemetry Connection Bar (Floating Dock)**:
   - Floats above bottom navigation in deep slate container (`bg-primary-container/95` with blur).
   - Rotating SVG spinner icon.
   - Connection status text: *"Connecting to Karigaar Guild... — WhatsApp Gateway Synced"*.
   - Live network beacon: Emerald dot with *"99.8%"* uptime indicator.
4. **Bottom Nav Bar Skeleton**:
   - 4-tab skeleton layout with Tab 1 active (radar icon in secondary amber).

---

### Screen 12: Karigaar App Icon & Logo (`karigaar_app_icon_logo`)
- **Target Persona**: Brand Asset / System Identity.
- **Format**: Scalable Vector Graphic (SVG, `viewBox="0 0 100 100"`).

#### Geometric & Semantic Breakdown
1. **Background**: `<rect width="100" height="100" rx="24" fill="#0F172A"/>`
   - Dark Guild Slate `#0F172A` providing rock-solid foundation, authority, and safety.
2. **Hexagonal Hardware Crest**: `<path d="M50 20L74 34V66L50 80L26 66V34L50 20Z" stroke="#F59E0B" stroke-width="4" fill="#1E293B"/>`
   - Hexagonal bolt silhouette in Artisan Amber `#F59E0B` representing trade mechanics, tools, and craftsmanship.
3. **Verification Checkmark**: `<path d="M38 52L46 60L64 42" stroke="#10B981" stroke-width="5" stroke-linecap="round"/>`
   - Bold Verified Emerald `#10B981` checkmark representing background verification, police vetting, and quality guarantee.
4. **Plumb Line & Level Indicator**: `<path d="M50 28V40" stroke="#F59E0B" stroke-width="3.5"/>` and `<circle cx="50" cy="50" r="3" fill="#F59E0B"/>`
   - Amber plumb line and pivot dot representing geometric precision, laser calibration, and artisanal integrity.

---

### Screen 13 (Architecture Baseline): Platform Gateway (`karigaar_artisan_home_services_platform`)
- **Target Persona**: Shared Auth / Root Layout Engine.
- **Analysis**: Establishes the core responsive wrapper (`min-height: max(884px, 100dvh)`, `overscroll-behavior: none`, safe-area inset management for notch and gesture home indicator), ensuring consistent touch targets across mobile OS versions.

---

## 3. Design System Foundations & Token Specifications

The visual identity of Karigaar is founded on **Tactile Modernism** with **Tonal Layering**, merging the solidity of high-grade construction materials with modern digital precision.

### 3.1 Color Palette Architecture (From `karigaar_artisan_trust/DESIGN.md`)

| Token Name | Hex Code | Material & Semantic Role | UI Application |
|:---|:---|:---|:---|
| **Primary (Deep Guild Slate)** | `#0F172A` / `#1E293B` | Structural authority, safety anchor | Authoritative headers, active tab icons, primary CTA backgrounds, dark container surfaces |
| **Primary Container** | `#131B2E` | Deep evening workshop tone | Hero cards, live tracking status header, active top bars |
| **Secondary (Artisan Amber)** | `#D97706` / `#F59E0B` | Artisanal ochre, focal warmth | Star ratings, skill badges, urgent highlights, active progress milestones, brand accents |
| **Secondary Container** | `#FE932C` | High-energy kinetic amber | Emergency dispatch countdowns, high-emphasis CTAs, OTP button active states |
| **Tertiary (Verified Emerald)** | `#059669` / `#10B981` | Trust, verified authenticity | "Police Verified" badges, "Guild Certified", warranty seals, successful transaction states |
| **Tertiary Container / Fixed** | `#002114` / `#85F8C4` | High-contrast trust accents | WhatsApp badge highlights, NSDC accreditation tags, live route completed sub-segments |
| **Surface Base (Canvas)** | `#F8FAFC` / `#F8F9FF` | Anti-glare tinted slate base | Viewport screen canvas background |
| **Surface Raised (Card)** | `#FFFFFF` | Elevated tactile touchplane | Cards, bottom sheets, sticky bars, floating action containers |
| **Surface Subtle / High** | `#F1F5F9` / `#DCE9FF` | Secondary grouping & inputs | Input backgrounds, unselected chips, divider tracks, status pills |
| **Text Primary (On-Surface)** | `#0B1C30` | High-legibility dark ink | Primary titles, price numbers, craftsman names |
| **Text Muted / Variant** | `#45464D` / `#64748B` | Secondary narrative | Sub-descriptions, location metadata, job timestamps |
| **Text Subtle / Outline** | `#76777D` / `#94A3B8` | Structural guidance | Form placeholders, inactive icons, hairline borders |
| **Border Subtle** | `#E2E8F0` / `#C6C6CD` | Precision hairline borders | Card outlines, table separators, avatar rings |
| **Error / Urgent** | `#BA1A1A` / `#FFDAD6` | Safety alerts, pass/decline | "SOS Help" button, dispute indicators, decline CTAs |

### 3.2 Dual Typography System
- **Headings & Brand Display**: `Plus Jakarta Sans` (weights: 400, 600, 700, 800)
  - `display-lg`: 32px / 40px line-height / -0.02em letter-spacing / 800 weight
  - `headline-lg`: 24px / 32px line-height / -0.015em letter-spacing / 700 weight
  - `headline-md`: 20px / 28px line-height / -0.01em letter-spacing / 600 weight
  - `body-lg`: 16px / 24px line-height / 400 weight
  - `body-md`: 14px / 20px line-height / 400 weight
- **Data, Pricing, Timers & Controls**: `Inter` (weights: 400, 600, 700)
  - `label-lg`: 14px / 20px line-height / +0.01em letter-spacing / 600 weight
  - `label-md`: 12px / 16px line-height / +0.02em letter-spacing / 600 weight
  - `label-sm`: 11px / 14px line-height / +0.04em letter-spacing / 700 weight (all caps status pills)
  - `numeric-price`: 22px / 28px line-height / -0.02em letter-spacing / 700 weight (tabular figures preventing jitter during live countdowns and currency balance updates)

### 3.3 Elevation, Geometry & Touch Ergonomics
- **Elevation Hierarchy**:
  - *Level 0 (Flat Canvas)*: `#F8FAFC` base viewport.
  - *Level 1 (Cards & Service Modules)*: `#FFFFFF`, `box-shadow: 0 1px 3px rgba(15,23,42,0.05), 0 1px 2px rgba(15,23,42,0.03)`, `border: 1px solid #E2E8F0`.
  - *Level 2 (Floating Micro-elements & Filter Chips)*: `box-shadow: 0 4px 6px -1px rgba(15,23,42,0.07)`.
  - *Level 3 (Modal Sheets & Floating Bottom Nav)*: `box-shadow: 0 10px 25px -5px rgba(15,23,42,0.12)`, backed by frosted glass backdrop blur (`backdrop-filter: blur(12px)` to `blur(16px)` with 85–90% opacity).
- **Rounding Radii**:
  - `rounded-md`: 12px (chips, inputs)
  - `rounded-xl / 2xl`: 16px to 24px (cards, drawers, modals)
  - `rounded-full`: 9999px (pills, badges, action buttons)
  - `squircle`: 14px to 16px corner radius for craftsman avatars with 2px emerald verification accents.
- **Touch Ergonomics**: All interactive touch targets strictly satisfy a minimum 48px height/width boundary, preventing mis-taps on motorcycle handlebars or amidst physical tool handling.

---

## 4. Dual Engagement Paths Mapping & Cross-Path Dynamics

```
                           ┌───────────────────────────┐
                           │   login_whatsapp_onboarding │
                           │ whatsapp_otp_verification │
                           └─────────────┬─────────────┘
                                         │
                                         ▼
                           ┌───────────────────────────┐
                           │       home_discovery      │
                           └─────────────┬─────────────┘
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 │                                               │
                 ▼                                               ▼
       [ PATH A: DIRECT CONTACT ]                      [ PATH B: STRUCTURED BOOKING ]
  ┌───────────────────────────────┐               ┌───────────────────────────────────┐
  │ karigaar_profile_reviews      │               │ service_details_custom_quote      │
  │ • Phone call link (tel:)      │               │ • Multi-issue selector            │
  │ • WhatsApp chat prefilled     │               │ • Visual/voice memo attach        │
  │ • Transparent visit rate ₹299 │               │ • Arrival time slot booking       │
  │ • 1-click Direct Hire CTA     │               │ • Guaranteed estimate calculation │
  └──────────────┬────────────────┘               └─────────────────┬─────────────────┘
                 │                                                  │
                 │                                                  ▼
                 │                                ┌───────────────────────────────────┐
                 │                                │ karigaar_partner_job_radar        │
                 │                                │ • 45s emergency broadcast timer   │
                 │                                │ • One-tap accept / pass           │
                 │                                │ • Customer photo & voice memo     │
                 │                                └─────────────────┬─────────────────┘
                 │                                                  │
                 │                                                  ▼
                 │                                ┌───────────────────────────────────┐
                 │                                │ active_job_live_tracking          │
                 │                                │ • Live GPS motorcycle marker      │
                 │                                │ • 4-digit Security Start OTP 4921 │
                 │                                │ • Milestone progress (1 to 5)     │
                 │                                │ • Canned communication chips      │
                 │                                └─────────────────┬─────────────────┘
                 │                                                  │
                 │                                                  ▼
                 │                                ┌───────────────────────────────────┐
                 │                                │ partner_active_job_wallet         │
                 │                                │ • Live work timer                 │
                 │                                │ • Extra parts billing + invoices  │
                 │                                │ • 4-digit Completion OTP verify   │
                 │                                │ • Instant IMPS wallet balance     │
                 └───────────────────────┬────────┴─────────────────┘
                                         │
                                         ▼
                           ┌───────────────────────────┐
                           │     super_admin_portal    │
                           │ • Live GMV & disputes     │
                           │ • 18-artisan KYC queue    │
                           │ • Surge WhatsApp broadcast│
                           └───────────────────────────┘
```

### 4.1 Path A: Direct Contact (Open Directory / Bidding Model)
- **Objective**: Cater to high-autonomy homeowners seeking master craftsmanship for complex or custom work (e.g. 60-year-old teak dining table restoration, full modular kitchen fitting) who prefer direct negotiation over algorithmic dispatch.
- **User Flow**:
  1. Customer browses Top Masters Nearby on `home_discovery`.
  2. Inspects master portfolio, verified credentials, and client scorecards on `karigaar_profile_reviews`.
  3. Initiates direct contact via phone call (`tel:`) or pre-filled WhatsApp message (`wa.me`).
  4. Agrees on an upfront inspection visit fee (e.g., ₹299, adjustable against final project bill).
- **Leakage Control**: If transacted purely offline, platform guarantees are void. The UI clearly reinforces that the **₹25,000 Guild Warranty** and **30-day rework protection** are activated only when booking through the platform.

### 4.2 Path B: Structured Booking (Managed Escrow Marketplace)
- **Objective**: Provide rapid, guaranteed resolution for emergency breakdowns (MCB tripping, burst pipes, broken locks) with full escrow protection.
- **User Flow**:
  1. Customer configures task, uploads photo, records 15s voice memo, and selects arrival slot on `service_details_custom_quote`.
  2. Job is broadcast to nearby online artisans via `karigaar_partner_job_radar` with a 45-second circular countdown timer.
  3. Artisan accepts; customer monitors en-route motorcycle on `active_job_live_tracking` with live ETA.
  4. Artisan arrives, enters customer's **Security Start Code (`4921`)** to begin work and start the job stopwatch.
  5. Artisan itemizes replacement parts with receipt photos on `partner_active_job_wallet`.
  6. Customer inspects work and releases the 4-digit **Job Completion OTP**.
  7. Payment is settled instantly to the artisan's Guild Wallet with zero-fee IMPS bank withdrawal.

### 4.3 Cross-Path Interoperability
- **Path A to Path B (Retroactive On-Site Formalization)**: When a direct visit turns into a major capital job (e.g., ₹18,000 kitchen cabinetry), the artisan or customer opens Karigaar on-site to lock a formal Structured Booking, funding the milestone into platform escrow to unlock the ₹25,000 warranty.
- **Path B to Path A (Pre-Flight WhatsApp Scoping)**: An artisan receiving a 45s dispatch taps *"Ask Customer on WhatsApp First"* to clarify breaker amperage or pipe diameters, ensuring the correct parts are packed while keeping the platform booking state machine alive.

---

## 5. Detailed Founder Requirements & Open Decisions Presentation

To transition from Phase 0 discovery into Phase 1 implementation, seven core architectural and business decisions require explicit founder sign-off. Below is an exhaustive presentation of each decision area, complete with strategic options, trade-offs, and recommended defaults.

---

### Decision 1: Pilot City Selection & Hyperlocal Operational Strategy
- **Background**: The reference screens specify operational coordinates in Gurugram / NCR (`home_discovery`, `active_job_live_tracking`, `karigaar_partner_job_radar`, `super_admin_portal`). Profile showcases also cite Bengaluru localities.
- **Strategic Options**:
  - **Option 1A: Gurugram Core Pilot (Cyber City, DLF Phase 1–5, Sector 42–48 Corridor)**:
    - *Pros*: Highest per-capita disposable income in India; dense gated condominiums with standardized security; acute willingness to pay for 25-minute emergency response; abundant migrant artisan clusters in Old Gurugram and Sector 14.
    - *Cons*: High summer temperatures strain HVAC supply; strong RWA gate protocols require digital pass management.
  - **Option 1B: Bengaluru (Indiranagar, HSR Layout, Koramangala)**:
    - *Pros*: Tech-savvy early adopters accustomed to on-demand apps.
    - *Cons*: Traffic gridlock stretches 2 km transit times beyond 35 minutes; regional language barriers (Kannada vs Hindi/Tamil).
  - **Option 1C: Mumbai / MMR (Powai, Thane, Western Suburbs)**:
    - *Pros*: High vertical density and acute plumbing/electrical breakdown frequency.
    - *Cons*: Severe intra-city travel friction; two-wheeler parking constraints in high-rise societies.
- **Operational Clustering Recommendation**: Launch strictly within a **contiguous 8-10 km corridor in Gurugram** (DLF Phase 1–5, Golf Course Road, and Sector 42–48; pincodes `122002`, `122009`, `122018`). Bounding dispatch to a 4 km artisan radius guarantees the 25-minute SLA.
- **Language Architecture**: Bilingual interface. Customer app defaults to English with Hindi toggle; Partner app defaults to Hindi with English toggle. Integrate WhatsApp audio memo streaming to cater to semi-literate artisans.
- **Recommended Default**: **Adopt Option 1A (Gurugram Corridor)** with bilingual Hindi/English and voice-first messaging.

---

### Decision 2: Initial Launch Categories & Service Taxonomy
- **Background**: The UI features an 8-trade grid on `home_discovery` and a 6-trade selector on `create_account_artisan_registration`. Launching too many categories simultaneously dilutes supply liquidity.
- **Strategic Options**:
  - **Option 2A: Focused Launch (3 Core Trades: Electrician, Plumber, Carpenter)**:
    - Focuses operational bandwidth on the most urgent and frequent home breakdown trades. High supply density and clear tool checklists.
  - **Option 2B: Full Grid Launch (All 8 Trades on Day 1)**:
    - Includes painting, masonry, pest control, appliances, and locksmiths. Risks severe supply shortages and unfulfilled dispatch SLAs.
  - **Option 2C: Phased Rollout (Wave 1: Core 3 Trades; Wave 2: AC & Appliances; Wave 3: Finishing Trades)**:
    - Launches Electrician, Plumber, and Carpenter on Day 1. Adds AC & Appliance Repair in Month 2 (ahead of summer peak). Defer Painting and Masonry to Month 4.
- **Task Scope Modeling**:
  - *Standard Repair Tasks (Path B)*: Predefined fixed-rate cards (e.g. MCB Tripping ₹249, Angle Valve ₹199) + standard visit diagnostic fee (₹199 for Electrical/Plumbing, ₹299 for Carpentry) + spare parts at actuals.
  - *Custom Projects (Path A)*: Site inspection with paid inspection fee (adjustable against bill) followed by milestone-based quotation.
- **Tool Audit Mandate**: Before partner duty activation, artisans must submit video/photo proof of calibrated tools (1000V insulated pliers, digital multimeter, laser level).
- **Recommended Default**: **Adopt Option 2C (Phased Rollout)** launching with Electrician, Plumber, and Carpenter in Month 1.

---

### Decision 3: Single vs Separate Mobile Applications
- **Background**: `login_whatsapp_onboarding` contains a role switcher tab (*Homeowner* vs *Karigaar*), while the Partner workflow incorporates high-frequency background GPS telemetry, 45-second circular timers, and bento dashboards.
- **Comparative Analysis Matrix**:

| Dimension | Option 3A: Unified Single App (Role Switcher) | Option 3B: Distinct Mobile Apps (Recommended) |
|:---|:---|:---|
| **App Store Optimization (ASO)** | Disastrous keyword dilution; consumer keywords clash with partner vocational search terms. | **Superior targeting**; separate campaigns for consumers vs tradespeople. |
| **Binary Size & Overhead** | 45MB+; bundles background location engines, OCR libraries, and siren audio into customer app. | **Lean binaries**; Customer app <20MB, Partner app ~25MB. |
| **Apple App Store Review** | **Extreme rejection risk** under Guideline 2.5.4 for background location tracking on a consumer app. | **Compliant**; Partner app legitimately declares enterprise dispatch telemetry. |
| **Artisan Cognitive Load** | Confusing; accidental mode switching leads to missed dispatches. | **Dead simple**; Partner app launches directly into Job Radar with large duty switch. |
| **Monorepo Architecture** | Single Flutter project. | Single monorepo sharing 70%+ core code (design tokens, models, API client). |

- **Recommended Default**: **Adopt Option 3B: Two Distinct Mobile Applications** (`Karigaar: Home Services` and `Karigaar Partner`) built in a single Flutter monorepo with a responsive Next.js Super Admin portal.

---

### Decision 4: Direct Contact Disclosure Policies & Disintermediation Control
- **Background**: `active_job_live_tracking` and `partner_active_job_wallet` feature call and WhatsApp buttons. Platform leakage occurs if customers and artisans bypass the platform for recurring work.
- **Strategic Options**:
  - **Option 4A: Full Open Contact Disclosure**:
    - Raw phone numbers displayed. Disintermediation reaches 70–85% after first visit. Customer privacy and safety are severely compromised.
  - **Option 4B: Virtual Masked Telephony (Recommended)**:
    - Direct calls are routed through an Exotel / Twilio virtual bridge. Numbers remain masked and expire 2 hours post-job. High customer safety and DPDP Act compliance.
  - **Option 4C: Paid Lead Unlock Model (Urban Company style)**:
    - Artisans pay ₹50–₹150 to unlock customer phone numbers. Customers are spammed by multiple competing contractors.
- **The Platform Retention Moat**: Masking alone cannot stop on-site verbal number exchange. Retention is enforced via economic and safety moats:
  1. *Customer Moat*: ₹25,000 Guild Damage Protection and 30-Day Free Rework Warranty apply strictly to platform-recorded jobs.
  2. *Artisan Moat*: Master Guildsman 0% Commission Tier (unlocked after 50 jobs) eliminates the financial incentive to bypass the platform.
  3. *Transaction Moat*: On-site Dynamic Bill Builder provides official 18% GST input invoices required by condominium residents for RWA maintenance claims.
- **Recommended Default**: **Adopt Option 4B: Virtual Masked Telephony** paired with the Platform Retention Moat.

---

### Decision 5: Booking State Machine Rules & Operational SLAs
- **Background**: The platform requires a deterministic state machine managing transitions across both Path A and Path B.
- **14-State Lifecycle Architecture**:
  1. `DRAFT`: Customer configures task, uploads photo/voice memo.
  2. `QUOTE_REQUESTED`: Path A project broadcasted to local guild masters.
  3. `QUOTES_RECEIVED`: Artisans submit itemized estimates.
  4. `QUOTE_ACCEPTED`: Customer selects winning bid.
  5. `DEPOSIT_ESCROWED`: Diagnostic fee or project advance authorized.
  6. `ARTISAN_DISPATCHED`: Nearest artisan accepts 45s dispatch prompt on Radar.
  7. `ARTISAN_ARRIVED`: Artisan taps arrival within 200m geofence.
  8. `IN_PROGRESS`: Artisan inputs customer's 4-digit Security Start Code (`4921`).
  9. `WORK_COMPLETED`: Artisan submits final bill with spare part receipts.
  10. `CUSTOMER_VERIFICATION`: Customer inspects work; provides 4-digit Completion OTP.
  11. `PAYMENT_RELEASED`: Escrow releases funds to Artisan Guild Wallet.
  12. `CLOSED`: Mutual ratings and reviews submitted; CSAT survey sent.
  13. `DISPUTED`: Issue raised; funds frozen for Super Admin arbitration.
  14. `CANCELLED`: Booking terminated subject to cancellation fee matrix.
- **Operational Timeouts & SLAs**:
  - Radar Dispatch Countdown: **45 seconds** (as modeled in UI).
  - Express Arrival SLA: **25 to 45 minutes**.
  - Arrival Grace Period: **15 minutes** beyond ETA.
  - Auto-Release Escrow Timer: **48 hours** post-completion if uncontested.
- **Cancellation Fee Matrix**:
  - Within 3 mins: Free cancellation (100% refund).
  - After dispatch (>5 mins): ₹99 transit fee deducted (₹80 credited to artisan for fuel/time; ₹19 platform fee).
  - At doorstep: Full visit fee charged (85% paid to artisan).
  - Artisan no-show (15 mins past grace): 100% refund + ₹100 apology credit; artisan suspended for 24 hours.
- **Recommended Default**: **Adopt the 14-State State Machine** and enforce the ₹99 transit cancellation fee.

---

### Decision 6: Core Business Rules, Monetization & Communications Architecture
- **Artisan KYC & Accreditation Tiers**:
  - *Tier 1 (Registered Partner)*: Phone verified + Aadhaar OCR match (DigiLocker/HyperVerge). Permitted to accept standard minor repairs.
  - *Tier 2 (Guild Verified Pro)*: Police background clearance + Penny-drop bank verification + Tool kit video audit. Unlocks 25-minute emergency dispatches.
  - *Tier 3 (Master Guildsman)*: NSDC / ITI trade diploma + 50 completed platform jobs with 4.85+ rating. Unlocks custom high-ticket projects and the **0% commission tier**.
- **Monetization Architecture**:
  - Path B Commission: **12% take-rate on labor charges**.
  - Customer Platform Safety & Insurance Fee: **Flat ₹29 per booking** (itemized on `service_details_custom_quote`). Directly funds third-party damage insurance cover.
  - Instant Withdrawal Fee: **₹0 promotional fee** on IMPS/UPI bank transfers.
- **Communications Infrastructure**:
  - Primary Vector: **WhatsApp Business Cloud API** for 1-tap OTP auth, dual-sync dispatch alerts (audio notes, gate PINs, GPS pins), emergency surge blasts, and CSAT surveys.
  - Fallback Vector: **Transactional SMS via DLT route** (Gupshup / Kaleyra / MSG91) triggered automatically if WhatsApp delivery is unconfirmed after 42 seconds.
- **Recommended Default**: **Adopt the 3-Tier KYC Model**, **12% labor take-rate + ₹29 safety fee**, and the **WhatsApp-First hybrid gateway with 42s SMS fallback**.

---

### Decision 7: Consolidated Founder Decision Matrix

The following decision matrix enumerates all required approvals. Every item includes its recommended default and direct architectural impact:

| ID | Strategic Decision Area | Core Founder Decision Statement | Recommended Default Choice | Architectural & Engineering Implication | Blocks Phase 1? |
|:---|:---|:---|:---|:---|:---|
| **D-01** | **Pilot City & Bounds** | Exact pilot municipality and micro-cluster coordinates. | **Gurugram: DLF Phase 1–5, Cyber City, Sector 42–48 corridor** (`122002`, `122009`, `122018`). | Configures Redis geospatial query bounding boxes and initial database seed data. | **YES** |
| **D-02** | **Launch Categories** | Scope of trades available on Day 1 vs subsequent phases. | **Wave 1: Electrician, Plumber, Carpenter**. Baseline diagnostic fee ₹199–₹299. | Defines service taxonomy schema, task configurator data models, and rate cards. | **YES** |
| **D-03** | **App Topology** | Single unified app with role switch vs distinct apps. | **Two Distinct Mobile Apps** (`Customer` & `Partner`) in a shared Flutter monorepo. | Dictates mobile monorepo scaffolding, ASO metadata, and background permission declarations. | **YES** |
| **D-04** | **Contact Disclosure** | Open telephone disclosure vs virtual masked telephony. | **Virtual Masked Telephony (Exotel/Twilio)** + Platform Moat (₹25k warranty). | Determines telephony microservice integration and masks raw phone numbers in APIs. | **YES** |
| **D-05** | **State Machine & SLAs** | Formal lifecycle transitions, 45s timer, and cancellation fees. | **14-State Lifecycle** with 45s dispatch timer, ₹99 transit fee, and 48h auto-release. | Drives the backend `booking_escrow_service` state machine engine and cron workers. | **YES** |
| **D-06** | **Monetization Model** | Platform take-rate, customer safety fee, and instant payouts. | **12% Labor Take-Rate + Flat ₹29 Safety Fee**; 0% Master Tier; ₹0 IMPS withdrawal. | Configures double-entry ledger calculation formulas and payment gateway split rules. | **YES** |
| **D-07** | **Messaging Strategy** | WhatsApp Cloud API allocation vs standard DLT SMS fallback. | **WhatsApp-First Hybrid Pipeline** with 42s automated DLT SMS fallback. | Governs notification service webhook infrastructure and communications cost budget. | **YES** |

---

## 6. Phase 1 Implementation Kickoff Checklist

Upon founder sign-off of the Consolidated Decision Matrix, Phase 1 engineering will commence immediately according to the following execution sequence:

1. **Repository & Infrastructure Initialization**:
   - Initialize Flutter/Dart & Node/Go monorepo structure as specified in `PROJECT.md`.
   - Setup Dockerized development environment (PostgreSQL 16, Redis 7, LocalStack S3).
   - Scaffold `packages/design_tokens` codifying the Slate/Amber/Emerald palette and typography.
2. **Identity & Authentication Engine**:
   - Deploy `services/auth_service` with WhatsApp Business Cloud API webhooks.
   - Implement +91 10-digit mobile input with 6-digit OTP auto-detection and 42s countdown.
   - Configure DLT-registered SMS gateway fallback (Gupshup/Kaleyra).
3. **Partner Registration & KYC Pipeline**:
   - Build 3-step artisan onboarding wizard in `apps/partner_mobile`.
   - Integrate Aadhaar OCR document parsing dropzone.
   - Setup Super Admin Priority Verification Queue in `apps/admin_web`.
4. **Telemetry & Shimmer Scaffolding**:
   - Implement 60fps shimmer loading engine and sticky telemetry dock in `apps/customer_mobile`.

---
*Authored by Teamwork Worker (`worker_phase0`). Comprehensive Phase 0 Review and Founder Requirements complete.*
