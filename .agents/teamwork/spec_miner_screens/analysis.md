# Phase 0 Specification & UI Design Token Analysis Report

**Target Asset Repository**: `c:\Users\asimf\Downloads\stitch_karigaar_app_ui\stitch_karigaar_app_ui`  
**Working Directory**: `c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\spec_miner_screens`  
**Date**: November 2026  
**Status**: Specification Complete (Read-Only Analysis, Zero Application Code)

---

## 1. Executive Summary & Design System Foundations

The provided UI design assets represent the complete frontend architecture and visual language for **Karigaar**, an on-demand artisanal craft marketplace connecting Indian households with verified, skilled craftsmen (carpenters, electricians, plumbers, masons, painters, AC/appliance technicians).

### 1.1 Brand Archetype & Design Tenor
- **Archetype**: *"Master Guildsman Meets Modern Concierge"*
- **Emotional Tenor**:
  1. *Trustworthy & Authoritative*: High assurance of safety, background verification (Aadhaar & Police), transparent pricing protection, and master craftsmanship.
  2. *Warm & Artisanal*: Deep respect for trade skills, tangible craftsmanship (polished teak wood, brass fittings, ambient workshop glow), moving away from cold gig-economy utility.
  3. *Modern & Kinetic*: Instant WhatsApp onboarding, live GPS dispatch tracking, rapid 45s broadcast timers, and friction-free micro-interactions.
- **Visual Style**: **Tactile Modernism** with crisp **Tonal Layering**. Deep Slate structural foundations offset with energetic Artisan Amber and trust-affirming Verified Emerald. Generous squircle curves (`rounded-2xl` / 16px) mitigate homeowner anxiety during home breakdown emergencies.

---

### 1.2 Design Tokens & Visual Specs (From `karigaar_artisan_trust/DESIGN.md`)

#### Color Palette Architecture
| Token Name | Hex Code | Material / Semantic Role | UI Usage |
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

#### Typography System
Built on dual font families balancing warm geometric curves with data-dense clarity:
- **Headings & Titles**: `Plus Jakarta Sans` (weights: 400, 600, 700, 800)
  - `display-lg`: 32px / 40px line-height / -0.02em letter-spacing / 800 weight
  - `headline-lg`: 24px / 32px line-height / -0.015em letter-spacing / 700 weight
  - `headline-md`: 20px / 28px line-height / -0.01em letter-spacing / 700 weight
  - `headline-sm`: 18px / 24px line-height / 600 weight
  - `body-lg`: 16px / 24px line-height / 400 weight
  - `body-md`: 14px / 20px line-height / 400 weight
  - `body-sm`: 12px / 16px line-height / 400 weight
- **Data, Pricing, Timers & Controls**: `Inter` (weights: 400, 600, 700)
  - `label-lg`: 14px / 20px line-height / +0.01em letter-spacing / 600 weight
  - `label-md`: 12px / 16px line-height / +0.02em letter-spacing / 600 weight
  - `label-sm`: 11px / 14px line-height / +0.04em letter-spacing / 700 weight (all caps pills)
  - `numeric-price`: 22px / 28px line-height / -0.02em letter-spacing / 700 weight (tabular figures preventing jitter during live price and countdown updates)

#### Elevation, Shapes & Depth
- **Level 0 (Flat Canvas)**: `#F8FAFC` base viewport.
- **Level 1 (Cards & Service Modules)**: `#FFFFFF`, `box-shadow: 0 1px 3px rgba(15,23,42,0.05), 0 1px 2px rgba(15,23,42,0.03)`, `border: 1px solid #E2E8F0`.
- **Level 2 (Floating Micro-elements & Filter Chips)**: `box-shadow: 0 4px 6px -1px rgba(15,23,42,0.07)`.
- **Level 3 (Modal Sheets & Floating Bottom Nav)**: `box-shadow: 0 10px 25px -5px rgba(15,23,42,0.12)`, backed by frosted glass backdrop blur (`backdrop-filter: blur(12px)` to `blur(16px)` with 85–90% opacity).
- **Rounding Radii**:
  - `rounded-sm`: 0.25rem (4px)
  - `rounded-DEFAULT`: 0.5rem (8px)
  - `rounded-md`: 0.75rem (12px)
  - `rounded-xl / 2xl`: 1rem to 1.5rem (16px to 24px) for cards, drawers, and modal pullouts
  - `rounded-full`: 9999px for pills, status chips, and action badges
  - `squircle`: 14px to 16px corner radius for craftsman avatars with 2px emerald verification accents.

#### Icon Design System
- Material Symbols Outlined (`Material Symbols Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200`)
- Standard optical size: 20px–24px for navigation, 16px–18px for badges, 12px–14px for inline micro-chips.
- Fill variation toggled selectively: `font-variation-settings: 'FILL' 1` for verified shields, star ratings, active bookmarks, and emergency bolts.

---

### 1.3 Karigaar App Icon Logo Vector Geometry (`karigaar_app_icon_logo`)
The application logo is an SVG (`viewBox="0 0 100 100"`):
1. **Squircle Foundation**: `<rect width="100" height="100" rx="24" fill="#0F172A"/>` — Deep Guild Slate background with 24px radius squircle geometry.
2. **Hexagonal Guild Crest**: `<path d="M50 20L74 34V66L50 80L26 66V34L50 20Z" stroke="#F59E0B" stroke-width="4" stroke-linejoin="round" fill="#1E293B"/>` — Symmetrical 6-sided bolt/nut geometry rendered in Artisan Amber outline with Slate container core, evoking hardware engineering and trade tools.
3. **Verified Checkmark**: `<path d="M38 52L46 60L64 42" stroke="#10B981" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>` — Verified Emerald thick checkmark at center, signaling verified safety and background vetting.
4. **Plumb Bob & Center Pivot**: `<path d="M50 28V40" stroke="#F59E0B" stroke-width="3.5" stroke-linecap="round"/>` and `<circle cx="50" cy="50" r="3" fill="#F59E0B"/>` — Vertical plumb line and pivot dot, symbolizing precision measurement and leveling.

---

## 2. Exhaustive Screen-by-Screen Specification

---

### Screen 1: Home Discovery (`home_discovery`)
- **Persona**: Customer (Homeowner / Resident)
- **Shell Type**: `mobile_tab` (Sticky header, scrolling body, fixed bottom tab navigation)
- **Viewport Target**: 390px baseline (mobile-first)

#### Layout Hierarchy & UI Components
1. **Header Bar**:
   - Left: Karigaar logo squircle (32px) + text "Karigaar Explore" + Location Dropdown ("Home • 42 Green Valley, Sector 4" with chevron).
   - Right: Notification Bell with unread amber dot badge + Homeowner profile photo thumbnail.
2. **Search & Action Bar**:
   - Full-width search pill (`#FFFFFF` background, rounded-xl, 48px height) with placeholder: *"Search electricians, carpenters, plumbers..."*.
   - Voice search microphone button (amber `#D97706`).
   - Filter adjustments icon button (`tune`).
3. **Emergency Quick-Assist 24x7 Banner**:
   - Gradient container (`from-secondary via-secondary-container to-amber-600`), pulsing green live beacon (`animate-ping`).
   - Copy: *"Urgent Breakdown? Get an artisan dispatched to your doorstep within 25 mins."*
   - CTA: *"Book Fast"* (bolt icon, active scale 95 micro-interaction).
4. **Trade Categories 8-Grid**:
   - Grid layout: 4 columns x 2 rows, each tile with tinted pastel background squircle (48px):
     1. Electrician (Amber tint, bolt)
     2. Carpenter (Orange tint, carpenter saw)
     3. Plumber (Blue tint, plumbing tap)
     4. Painter (Purple tint, format_paint)
     5. Appliance (Cyan tint, mode_fan)
     6. Masonry (Stone tint, foundation)
     7. Pest Guard (Emerald tint, pest_control)
     8. Locksmith (Amber-warm tint, lock_reset)
   - Header control: *"Artisan Guilds"* with *"All (14)"* category counter link.
5. **The Karigaar Shield Commitment Banner**:
   - 3-column trust module:
     - 100% Police Verified (Background vetted)
     - Rate Card Protection (No hidden surprises)
     - 30-Day Guarantee (Free rework cover)
6. **Top Rated Karigaars Nearby Stack (Sector 4)**:
   - Live dispatch indicator dot + "Live Dispatch" pill.
   - **Craftsman Card 1**: Rajesh Sharma
     - Master Carpenter, 8 yrs exp, 1.4 km away
     - Rating: 4.9 (320 reviews)
     - Badges: "Police Verified" (Emerald pill), "Super Artisan"
     - Microcopy quote: *“Specialist in modular kitchen fittings, veneer repairs & high-security door locks.”*
     - Inspection fee: `₹299` ("adjustable in bill")
     - CTA: *"Hire Artisan"* (deep slate button with arrow)
   - **Craftsman Card 2**: Tariq Anwar
     - Certified Electrician, 12 yrs exp, 2.1 km away
     - Rating: 4.8 (410 reviews)
     - Badges: "Police Verified", "Heavy Power Expert"
     - Microcopy quote: *“Inverter wiring, MCB recurring tripping, chandelier setup & smart switches.”*
     - Inspection fee: `₹199` ("adjustable in bill")
     - CTA: *"Hire Artisan"*
7. **Curated Guild Packages (Seasonal Bundles)**:
   - AC Deep Service & Jet Clean (Summer Prep Bundle, 20% OFF tag, ₹599 slashed from ₹749, "Add +" CTA).
   - Full Home Electrical Audit (Safety First, POPULAR tag, 32-point earthing and surge test, ₹799 slashed from ₹999, "Add +" CTA).
8. **Interactive Custom Quote Teaser**:
   - Handshake badge: *"Need a custom estimation? Post your requirement & receive bids from verified masters within 15 mins."* -> CTA *"Post Job"*.
9. **Fixed Bottom Navigation Bar**:
   - 4 Tabs: Explore (Active, `#000000`), Bookings, Messages (with unread badge counter '2'), Profile.

#### States & Micro-Interactions
- **Search Focused**: Transitions from subtle shadow to elevated shadow with border highlight.
- **Card Taps**: 95% scale active down-state.
- **Location Selector**: Tapping opens address picker modal.

---

### Screen 2: Service Details & Custom Quote (`service_details_custom_quote`)
- **Persona**: Customer (Homeowner configuring a repair package)
- **Shell Type**: `mobile_stack` (Back navigation arrow, page title "Booking Flow", profile avatar)

#### Layout Hierarchy & UI Components
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
   - Micro-interaction: Tapping an issue card dynamically toggles selection, updates indicator icon, and triggers real-time price recalculation in the checkout dock.
3. **Upload Issue Visual & Audio Voice Memo**:
   - Visual attachment row: Thumbnail preview of uploaded electrical breaker (`main_mcb_panel.jpg` with remove "X" button) + "Add photo" slot (`input type="file"`).
   - Helper microcopy: *"Helps your Karigaar pack compatible switches, testers, and correct amp fuses."*
   - Audio note: *"Add 15s voice note for Karigaar"* with *"Record"* button.
4. **Preferred Schedule Slot Carousel**:
   - Date carousel chips:
     - *Fastest: Today, 45m* (Default active, primary slate)
     - *Tomorrow: Oct 14*
     - *Wednesday: Oct 15*
     - *Thursday: Oct 16*
   - Time slot vertical stack:
     - Morning slot: *09:00 AM – 11:00 AM*
     - Afternoon slot: *02:00 PM – 04:00 PM* (Marked "Popular", amber tag)
     - Evening slot: *05:00 PM – 07:00 PM*
5. **Price Transparency Breakdown**:
   - Standard Diagnostic & Visit: `₹199`
   - Configured Issue / Task: `₹249` (Dynamic label and price)
   - Karigaar Safety & Insurance Shield: `₹29`
   - Total Guaranteed Estimate: `₹477` (*"Final bill adjusted only if new hardware required"*)
   - Trust note: *"No advance needed. Inspect work before releasing OTP payment."*
6. **Sticky Frosted Bottom Checkout Dock**:
   - Left: `₹477 all incl.` + `45m estimate` timer icon.
   - Right: Amber CTA *"Select Karigaar"* with arrow.
   - Micro-interaction: Tapping CTA triggers loading spinner state (*"Finding Karigaars..."*) followed after 1200ms by matched state (*"3 Matched!"* in emerald).

---

### Screen 3: Active Job Live Tracking (`active_job_live_tracking`)
- **Persona**: Customer (Homeowner tracking assigned artisan en route and during work)
- **Shell Type**: `mobile_stack` (Back button, Title: "Live Dispatch Tracking", Profile icon)

#### Layout Hierarchy & UI Components
1. **Top Utility Bar**:
   - Live pulsing emerald beacon + Job `#KG-8842` + Category pill *"Woodwork"*.
   - Action buttons: *"SOS Help"* (Red error-container) and *"Minimize Map"* toggle.
2. **Live Map Canvas (Height 288px)**:
   - Visual map canvas (Gurgaon Sector 48, 42 Green Valley neighborhood).
   - Multi-segment SVG route polyline:
     - Completed sub-segment in Verified Emerald (`#069669`).
     - Active route polyline in Artisan Amber (`#FE932C`).
     - Planned route glow path in Deep Slate (`#131B2E`).
   - Bouncing Destination Pin at homeowner's location (*"42 Green Valley"*).
   - Moving Artisan Motorcycle Marker (`two_wheeler` icon) with double pulsing radar wave and real-time floating ETA pill: *"ETA 14 min (1.8 km)"*.
   - Floating map controls: Re-center on Karigaar (`near_me`), Toggle Traffic layer (`traffic`).
3. **Real-Time Job Status Card**:
   - Headline: *"Artisan On The Way"* (Arriving by 02:35 PM • 14 mins remaining • "On Time" chip).
   - 5-Step Segmented Milestone Progress Track:
     1. Booking Confirmed (02:10 PM) — [Completed / Checkmark]
     2. Karigaar Dispatched (02:18 PM) — [Completed / Checkmark]
     3. On the Way (Passing Cyber Hub) — [Active / Spinning sync icon]
     4. Job Execution — [Pending OTP release]
     5. Quality Sign-off — [Estimated 03:45 PM]
4. **Assigned Karigaar Profile Module**:
   - Avatar squircle with verified badge: Rajesh Kumar, Master Carpenter, 11+ yrs exp, Guild Pro, 4.9 rating (418 jobs).
   - **Security Start Code Box**:
     - Label: *"Security Start Code — Share only after Rajesh arrives"*
     - Large numeric PIN block: **`4921`** (4-digit security token required to start job).
   - Quick contact buttons: *"Call Artisan"* (`tel:+919876543210`) & *"Send Message"* (opens modal drawer).
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
   - Full-width button: *"Share Live Tracking with Family"*
   - Footer links: *"Need to Reschedule?"* | *"Cancel Booking"* (in error red)
8. **Interactive Quick Messaging Modal Drawer**:
   - Pull-up sheet: *"Direct Chat with Rajesh — Online & Riding"*.
   - Verbatim dialogue:
     - Artisan: *"Namaste Ji, I have collected the required precision drill bits. I will reach in about 14 minutes."*
     - Homeowner: *"Sure Rajesh! Gate security has already been notified of your vehicle."*
   - Input field with send button.

---

### Screen 4: Create Account & Artisan Registration (`create_account_artisan_registration`)
- **Persona**: Artisan / Tradesperson (Partner Onboarding Step 1 of 3)
- **Shell Type**: `mobile_stack` (Back button, Karigaar logo, title, avatar)

#### Layout Hierarchy & UI Components
1. **Onboarding Sub-Header & Step Indicator**:
   - Sub-bar: Step 1 indicator circle + text *"Step 1 of 3: Profile & Trade"*.
   - Dual Language Toggle Pill: `English` | `हिंदी` (bilingual toggle for Hindi/English trade terminology).
   - Animated progress bar: 33.3% filled.
2. **Guild Welcome & Earning Proposition Card**:
   - Deep slate container: *"Join the Karigaar Guild"*.
   - Badges: *"Guild Accreditation"* & *"0% Commission Offer"*.
   - Value prop: *"Connect directly with premium households in your pin code. Transparent daily payouts and guild master insurance cover."*
   - Earnings trust strip: *"Over ₹42,000/mo Avg. Earnings — Join 12,400+ verified professionals across NCR & MMR"*.
3. **Role Switcher Segmented Control**:
   - Segmented toggle: *"I am a Karigaar"* (Active, handyman icon, amber dot) vs *"I am a Customer"* (roofing icon).
4. **Primary Trade Selection 2-Column Grid**:
   - Selectable cards with trade icons and checkmarks:
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
   - Dropzone with bouncing camera icon: *"Capture Front of Aadhaar Card — Clear photo • Max size 10MB (JPG/PNG)"*.
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
- **Persona**: Shared Auth (Homeowner and Artisan / Partner entering the platform)
- **Shell Type**: `mobile_auth` (Full-height authentication layout)

#### Layout Hierarchy & UI Components
1. **Header**:
   - Karigaar logo squircle + text "Karigaar".
   - Language selector pill: `translate` icon + *"EN / HI"*.
   - Homeowner avatar thumbnail.
2. **Warm Artisanal Greeting Banner**:
   - Badge: *"Guild Certified Safe"* (secondary amber with verified checkmark).
   - Main heading: *"Welcome to Karigaar"*.
   - Bilingual Hindi tagline: **"भारत के सबसे भरोसेमंद कारीगर"** (*India's Most Trusted Artisans*).
   - Subtext: *"Book verified master tradespeople or get hired for high-ticket local jobs."*
   - Visual: High-craft photography of Indian craftsman hands polishing teak wood joint with brass tools.
3. **Role Switcher Segmented Tabs**:
   - Tab 1: **Homeowner** (*"Hire an Expert"*, home repair service icon).
   - Tab 2: **Karigaar** (*"Work & Earn"*, handyman icon).
   - Interactive behavior: Switching tabs toggles dynamic promotional content and adjusts onboarding paths.
4. **Dynamic Artisan Benefit Banner (Toggled when Karigaar tab selected)**:
   - Header: *"New Artisan? Register in 2 mins"* + *"0% Commission Month"* badge.
   - Copy: *"Select your craft to start getting instant nearby home bookings directly on WhatsApp:"*
   - Horizontal trade categories: Electrician, Carpenter, Plumber, Painter, AC Tech.
   - Trust checklist:
     - `Aadhaar KYC` (id_card icon)
     - `Tool Insurance` (shield icon)
     - `Daily Payouts` (currency_rupee icon)
5. **Main Authentication Action Container**:
   - **Primary Action (1-Tap WhatsApp Login)**:
     - Massive button (56px min-height) in Official WhatsApp / Emerald Green (`#069669` / `bg-on-tertiary-container`).
     - WhatsApp SVG vector icon in pure white.
     - Title: *"Instant Login with WhatsApp"*.
     - Subtitle: *"1-Tap instant OTP & updates on +91 WhatsApp"*.
     - Right arrow icon.
   - Divider: *"or continue with mobile number"*.
   - **Mobile Number Entry Form**:
     - Label: *"Mobile Phone Number"* with sub-label *"SMS verification fallback"*.
     - 🇮🇳 +91 country chip with Indian flag and chevron.
     - 10-digit telephone input (`inputmode="numeric"`, `font-numeric-price`).
     - Submit CTA: *"Get Verification Code"* (lock icon; dynamically activates to amber `bg-secondary-container` when 10 digits are typed).
   - Consent microcopy: *"By continuing, you agree to Karigaar Guild's Terms of Service & Privacy Code."*
6. **Craft Guild Trust Strip (3-Column)**:
   - *256-bit Encrypted* — Bank-Grade Privacy
   - *NSDC Partner* — Skill Verified Guild (National Skill Development Corporation reference)
   - *Guaranteed Rate* — Zero Hidden Charges
7. **Human Concierge Support Touchpoint**:
   - Support agent avatar: *"Need help getting started? Chat with Guild Concierge on WhatsApp"*.
   - Button: *"Chat Now"* (direct WhatsApp link to `https://wa.me/919999999999`).

---

### Screen 6: WhatsApp OTP Verification Modal (`whatsapp_otp_verification_modal`)
- **Persona**: Shared Auth (Customer or Artisan completing 2-factor authentication)
- **Shell Type**: `mobile_auth` Modal Sheet / Bottom Sheet Overlay

#### Layout Hierarchy & UI Components
1. **Modal Architecture**:
   - Semi-transparent backdrop (`bg-black/60 backdrop-blur-sm`).
   - Bottom sheet on mobile (`rounded-t-3xl`), centered dialog on desktop/tablet (`sm:rounded-3xl`).
   - Mobile pull handle indicator (40px wide pill).
2. **Modal Header**:
   - WhatsApp icon badge (`#25D366` green background container).
   - Pill: *"Guild Instant WhatsApp Auth"* with lock icon.
   - Title: *"Verify WhatsApp Number"*.
   - Close circular button (`close` icon).
3. **Phone Context & Edit Action**:
   - Row showing recipient number: *"Code sent to +91 98104 22910"*.
   - Right action: *"Edit Number"* (closes modal and returns focus to phone input).
4. **6-Digit OTP Interactive Input Matrix**:
   - 6 individual numeric boxes (48px–56px wide x 56px–64px high, `font-numeric-price`, bold).
   - Full keyboard navigation:
     - Auto-advances focus to next box upon single digit input.
     - Backspace clears and retreats focus to previous box.
     - Left and Right arrow key navigation supported.
     - Clipboard paste handler automatically distributes 6 digits across boxes.
   - Microcopy: *"Auto-detecting WhatsApp code..."*.
5. **Countdown Timer & Fallback Communication Channels**:
   - Resend timer: *"Resend code in 00:42"* ticking down to `00:00`.
   - *"Resend OTP"* button (disabled with muted styling until countdown reaches zero, then activates to amber).
   - SMS Fallback: *"Didn't receive code on WhatsApp? Send via SMS"* (triggers SMS fallback dispatch).
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
- **Persona**: Artisan / Tradesperson ("Karigaar Partner")
- **Shell Type**: `karigaar_partner_tab` (Radar, My Jobs, Wallet, Guild bottom tabs)

#### Layout Hierarchy & UI Components
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
     - Dynamic text: `45s`, `44s`, ... down to `0s`.
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
- **Persona**: Artisan / Tradesperson executing active work & managing wallet earnings
- **Shell Type**: `karigaar_partner_tab` (My Jobs tab active in bottom nav)

#### Layout Hierarchy & UI Components
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
- **Persona**: Customer evaluating an artisan / Public Master Profile
- **Shell Type**: `mobile_stack` (Back navigation, title "Craftsman Profile", profile avatar)

#### Layout Hierarchy & UI Components
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
   - Sawdust & Cleanliness: `5.0 / 5.0` (100% bar) — *Directly addresses a primary Indian household pain point regarding home renovation mess!*
6. **Recent Client Feedback & Verified Reviews**:
   - Review 1: Pooja M. (Defense Colony, 5 stars, *"Verified Main Door Repair Job"*) — Arrived in 20 mins with laser toolkit, fixed jamming Burma teak door, super polite, cleaned sawdust before leaving.
   - Review 2: Amit V. (HAL 2nd Stage, 5 stars, *"Verified Modular Kitchen Fitting"*) — Replaced 6 drawer channels with soft-close Blum fittings, transparent billing.
7. **Sticky Bottom Concierge Action Dock**:
   - Left: `₹299 / visit` + *"Includes ₹25k Guild Warranty"*.
   - Right: Full CTA *"Book Rajesh Now"* (taps transition to *"Securing Slot..."* -> *"Slot Reserved!"* in emerald).

---

### Screen 10: Super Admin Operations Portal (`super_admin_portal`)
- **Persona**: Super Admin / Platform Operator
- **Shell Type**: `super_admin_mobile` (Mobile-optimized executive operations dashboard)

#### Layout Hierarchy & UI Components
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
- **Persona**: Shared Loading State (Customer or Partner waiting for GPS sync, search query, or radar dispatch)
- **Shell Type**: `mobile_stack` skeleton view

#### Layout Hierarchy & Animation Architecture
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
- **Persona**: Brand Asset / System Identity
- **Format**: Scalable Vector Graphic (SVG)

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

### Additional Screen: Karigaar Artisan Platform Gateway (`karigaar_artisan_home_services_platform`)
- **Persona**: Shared Auth / Portal
- **Analysis**: Contains the underlying shared authentication layout and responsive baseline identical to `login_whatsapp_onboarding`, establishing the root responsive layout wrapper (`min-height: max(884px, 100dvh)`, `overscroll-behavior: none`, safe-area inset management for notch and home indicator).

---

## 3. Dual Engagement Workflow Mapping

The 12 screens directly map to the two foundational user journeys required by the business architecture:

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
                 ┌──────────────────────┴──────────────────────┐
                 │                                             │
                 ▼                                             ▼
       [ PATH A: DIRECT CONTACT ]                    [ PATH B: STRUCTURED BOOKING ]
  ┌───────────────────────────────┐             ┌───────────────────────────────────┐
  │ karigaar_profile_reviews      │             │ service_details_custom_quote      │
  │ • Phone call link (tel:)      │             │ • Multi-issue selector            │
  │ • WhatsApp chat prefilled     │             │ • Visual/voice memo attach        │
  │ • Transparent visit rate ₹299 │             │ • Arrival time slot booking       │
  │ • 1-click Direct Hire CTA     │             │ • Guaranteed estimate calculation │
  └──────────────┬────────────────┘             └─────────────────┬─────────────────┘
                 │                                                │
                 │                                                ▼
                 │                              ┌───────────────────────────────────┐
                 │                              │ karigaar_partner_job_radar        │
                 │                              │ • 45s emergency broadcast timer   │
                 │                              │ • One-tap accept / pass           │
                 │                              │ • Customer photo & voice memo     │
                 │                              └─────────────────┬─────────────────┘
                 │                                                │
                 │                                                ▼
                 │                              ┌───────────────────────────────────┐
                 │                              │ active_job_live_tracking          │
                 │                              │ • Live GPS motorcycle marker      │
                 │                              │ • 4-digit Security Start OTP 4921 │
                 │                              │ • Milestone progress (1 to 5)     │
                 │                              │ • Canned communication chips      │
                 │                              └─────────────────┬─────────────────┘
                 │                                                │
                 │                                                ▼
                 │                              ┌───────────────────────────────────┐
                 │                              │ partner_active_job_wallet         │
                 │                              │ • Live work timer                 │
                 │                              │ • Extra parts billing + invoices  │
                 │                              │ • 4-digit Completion OTP verify   │
                 │                              │ • Instant IMPS wallet balance     │
                 └──────────────────────┬───────┴─────────────────┘
                                        │
                                        ▼
                          ┌───────────────────────────┐
                          │     super_admin_portal    │
                          │ • Live GMV & disputes     │
                          │ • 18-artisan KYC queue    │
                          │ • Surge WhatsApp broadcast│
                          └───────────────────────────┘
```

### Path A: Direct Contact Flow
1. Homeowner searches or browses categories on `home_discovery`.
2. Inspects master craftsman profile on `karigaar_profile_reviews`.
3. Initiates direct contact via `tel:` phone call or direct `wa.me` WhatsApp chat.
4. Retains upfront visit fee transparency (`₹299/visit`) and ₹25,000 guild warranty.

### Path B: Structured In-App Booking Flow
1. Homeowner selects service, configures issues, attaches photo/voice note, and picks arrival slot on `service_details_custom_quote`.
2. Job is broadcast to verified partners on `karigaar_partner_job_radar` with a 45-second animated countdown timer.
3. Partner accepts; customer monitors dispatch on `active_job_live_tracking` with live GPS route and provides **Security Start Code (`4921`)**.
4. Partner executes repair, adds parts/materials to invoice, and enters **Completion OTP** on `partner_active_job_wallet`.
5. Instant settlement credits to Partner Guild Wallet with zero deduction IMPS payout.
6. Ops monitored in real-time via `super_admin_portal`.

---

## 4. Localized Indian Context & Trust Architecture

The UI designs are deeply tailored to the socioeconomic realities and digital habits of Indian households and blue-collar tradespeople:

1. **WhatsApp as Primary Infrastructure**:
   - 1-Tap WhatsApp authentication replaces cumbersome email/password or flaky SMS gateways.
   - Dual Sync Bot: Voice notes, gate pass PINs, and exact GPS pins stream directly to the partner's WhatsApp.
   - Partner dispatch alert includes pre-filled WhatsApp link (*"Ask Customer on WhatsApp First"*).
   - Automated post-service CSAT collection conducted over WhatsApp (94% 5-star across 1,180 reviews).
2. **Bilingual / Localized Microcopy**:
   - Prominent Hindi tagline: **"भारत के सबसे भरोसेमंद कारीगर"** (*India's Most Trusted Artisans*).
   - Header language toggle pill: `English` | `हिंदी` (`EN / HI`).
   - Cultural greetings in chat: *"Namaste Ji, I have collected the required precision drill bits..."*.
3. **Indian Neighborhood & Geographic Realism**:
   - Gurgaon / NCR launch geography: *DLF Phase 4, Cyber City, Sector 4, Sector 5, Sector 42 Green Valley, Sector 48 Sohna Road, Sushant Lok 1, South City 2*.
   - Bengaluru references in profile gallery: *Indiranagar 100ft Rd, Koramangala 4th Block, HSR Layout Sector 2, HAL 2nd Stage, Defense Colony*.
4. **Indian Currency & Pricing Psychology**:
   - Indian Rupee symbol (`₹`) formatted with tabular numbers.
   - Transparent price anchoring:
     - Diagnostic visit fee: `₹199` to `₹299` ("adjustable in bill").
     - Karigaar Safety & Insurance Shield: `₹29`.
     - "No advance needed. Inspect work before releasing OTP payment."
     - Instant zero-fee IMPS daily payout to partner bank accounts (e.g. HDFC Bank).
5. **Hyper-Specific Trust & Verification Badges**:
   - **Aadhaar KYC**: National identity verification.
   - **Police Clearance**: Background vetting certificate.
   - **NSDC Partner**: National Skill Development Corporation skill accreditation.
   - **Sawdust & Cleanliness Score (5.0/5.0)**: Dedicated metric for clean post-service cleanup, addressing a primary friction point in Indian home maintenance.
   - **Gate Pass & Visitor Parking Chips**: Canned chips addressing gated Indian residential society security protocols (*"Gate code is 8842"*, *"Visitor parking spot #4"*).

---

## 5. Features Discovered Table

| # | Category | Feature | Description | Inputs | Outputs | Error Behavior | Discovered Via |
|---|:---|:---|:---|:---|:---|:---|:---|
| 1 | Auth & Onboarding | Instant WhatsApp Login | 1-Tap passwordless authentication via WhatsApp OAuth/API | Phone Number, WhatsApp tap | Session token, redirect to role home | Fallback to SMS verification if WhatsApp fails | `login_whatsapp_onboarding` |
| 2 | Auth & Onboarding | Segmented Role Switcher | Client-side tab toggle between Homeowner and Karigaar | Click event on role tabs | Modifies view layout & promo banners | Defaults to Homeowner if unset | `login_whatsapp_onboarding` |
| 3 | Auth & Onboarding | 6-Digit OTP Auto-Advance | Interactive OTP input matrix with clipboard paste & keyboard nav | 6 numeric digits, paste text | Auto-focuses next input, triggers submit | Rejects non-numeric, retains invalid box focus | `whatsapp_otp_verification_modal` |
| 4 | Auth & Onboarding | Resend OTP Countdown | 42s countdown timer disabling resend until expiry | Wall clock time (1s tick) | Timer string, enables active resend button | Resets timer on resend click | `whatsapp_otp_verification_modal` |
| 5 | Auth & Onboarding | SMS Fallback Trigger | Secondary SMS dispatch when WhatsApp delivery is delayed | User click on fallback link | Alert confirmation, resets countdown | Fallback unavailable without valid phone | `whatsapp_otp_verification_modal` |
| 6 | Discovery | 8-Grid Category Navigation | Grid of primary trade crafts with dedicated color accents | Category card click | Filtered artisan/package listings | Default all categories if none clicked | `home_discovery` |
| 7 | Discovery | Emergency 24x7 Dispatch | Rapid assistance banner guaranteeing doorstep dispatch in 25 mins | Click "Book Fast" | Directs to urgent booking flow | Shows queue message if all artisans busy | `home_discovery` |
| 8 | Discovery | Curated Service Packages | Bundled preventive maintenance with discounted pricing | Click "Add +" on package | Adds bundle to checkout cart | Displays "Out of stock" if capacity full | `home_discovery` |
| 9 | Booking & Quote | Dynamic Task Configurator | Multi-issue selector calculating real-time pricing | Task card selection click | Updates task label and dock total | Requires at least 1 task selected | `service_details_custom_quote` |
| 10 | Booking & Quote | Media & Voice Memo Attach | Multi-modal issue documentation (photo + 15s audio note) | Image file upload, audio recording | Upload thumbnail, audio payload | Max 10MB limit on image files | `service_details_custom_quote` |
| 11 | Booking & Quote | Scheduled Slot Picker | Horizontal date carousel + morning/afternoon/evening time slots | Date chip tap, time slot tap | Scheduled arrival window selection | Highlights slot conflict if unavailable | `service_details_custom_quote` |
| 12 | Live Tracking | Live Vector Map & Polyline | Real-time map displaying artisan motorcycle marker and route | GPS coordinates stream | SVG polyline (completed/active/planned) | Shows static map fallback if GPS lost | `active_job_live_tracking` |
| 13 | Live Tracking | Security Start OTP | 4-digit security code generated for homeowner to share on arrival | Booking generation | Code displayed (`4921`) | Job cannot start without artisan entry | `active_job_live_tracking` |
| 14 | Live Tracking | 5-Stage Milestone Progress | Step-by-step progress tracking from dispatch to sign-off | Server milestone events | Visual step indicator & timestamps | Flags delays if SLA exceeded | `active_job_live_tracking` |
| 15 | Live Tracking | In-App Direct Chat Drawer | Slide-up modal chat with assigned artisan | Text input, send button | Message bubble thread | Prompts WhatsApp redirect if offline | `active_job_live_tracking` |
| 16 | Partner Ops | 45-Second Dispatch Radar Timer | Circular SVG countdown timer for incoming emergency jobs | 45s server countdown | Circular progress stroke, second counter | Auto-expires card at 0s, disables accept | `karigaar_partner_job_radar` |
| 17 | Partner Ops | Duty Status Toggle | Partner toggle to pause or activate job dispatch radar | Toggle button click | "Active" (online) vs "Paused" (offline) | Prevents dispatches when paused | `karigaar_partner_job_radar` |
| 18 | Partner Ops | Pre-Accept WhatsApp Inquiry | Direct pre-filled WhatsApp link to communicate before accepting | Click "Ask Customer" | Launches `wa.me` with prefilled draft | Requires WhatsApp installed on device | `karigaar_partner_job_radar` |
| 19 | Partner Ops | Broadcast Job Claiming | Nearby broadcast job feed with one-tap claim action | Click "Claim Job" | Locks job, transitions to "Locked & Assigned" | Rejects if another partner claimed first | `karigaar_partner_job_radar` |
| 20 | Invoicing & Wallet | Live Job Stopwatch | Elapsed execution timer tracking on-site repair duration | Timer start event on arrival | Digital display (e.g. `28m 14s`) | Auto-pauses on network disconnect | `partner_active_job_wallet` |
| 21 | Invoicing & Wallet | Material & Parts Bill Builder | Dynamic addition of spare parts with receipt photo attachment | Part name, quantity, price, photo | Itemized line item + GST recalculation | Flags missing receipt if required by policy | `partner_active_job_wallet` |
| 22 | Invoicing & Wallet | Completion OTP Verification | 4-digit PIN verification to complete work and authorize payment | Customer verbal PIN input | Verifies code, triggers payment collection | Error on incorrect PIN entry | `partner_active_job_wallet` |
| 23 | Invoicing & Wallet | Instant IMPS Bank Withdrawal | 24/7 zero-fee withdrawal from Guild Wallet to linked bank | Click "Withdraw to Bank" | IMPS payout initiated, ledger updated | Fails if balance below threshold | `partner_active_job_wallet` |
| 24 | Invoicing & Wallet | Guild Tier Level Progress | Milestone progress tracking to unlock 0% commission tier | Completed job counter | Tier level badge, progress gauge (84%) | Tier downgrade if acceptance drops | `partner_active_job_wallet` |
| 25 | Profile & Trust | Triple-Screened Guild Badge | Display of Govt ID, Police, NSDC, and ₹25k insurance cover | Profile view | Visual credential pods | Displays "Under Review" if pending | `karigaar_profile_reviews` |
| 26 | Profile & Trust | Cleanliness & Sawdust Score | Specific cleanliness rating alongside punctuality and craft | Post-service customer review | Score bar out of 5.0 | Excludes score if insufficient reviews | `karigaar_profile_reviews` |
| 27 | Profile & Trust | Bleeding Portfolio Showcase | Horizontal photo carousel of verified past residential work | Work gallery array | Full-bleed cards with duration & locality | Empty placeholder if no photos uploaded | `karigaar_profile_reviews` |
| 28 | Admin Ops | Live Ops Pulse Stream | Live counters for active dispatches, available artisans, disputes | Real-time WebSocket stream | Metric chips (Active: 142, Available: 89) | Re-connect banner if stream interrupted | `super_admin_portal` |
| 29 | Admin Ops | Surge Radar Heatmap | Zone-level demand surge detection with surge pricing multiplier | Zone demand/supply ratio | "Surge 1.4x" alert, deficit warning | Normal rate card restored when balanced | `super_admin_portal` |
| 30 | Admin Ops | Trade Volume Mix Breakdown | Multi-segmented progress bar showing category percentage mix | Daily dispatch aggregation | Segmented bar (Electrician 38%, etc.) | Zero state for unlaunched categories | `super_admin_portal` |
| 31 | Admin Ops | Artisan Verification Queue | KYC review interface for approving or rejecting artisan candidates | Admin click "Approve" / "Reject" | Updates artisan status, triggers WhatsApp alert | Flags missing documents (e.g. calibration) | `super_admin_portal` |
| 32 | Admin Ops | WhatsApp Emergency Broadcast | Blast push message to standby artisans in specific radius | Target zone, radius, bonus surcharge | WhatsApp broadcast sent to N technicians | API rate limit error handling | `super_admin_portal` |
| 33 | System UX | Skeleton Shimmer Loading | Custom CSS keyframe shimmer for loading radar cards | Data fetch lifecycle | Shimmering layout placeholders | Fallback error retry if fetch times out | `skeleton_loading_radar_sync` |
| 34 | Identity | Scalable Vector Brand Logo | Precision SVG mark combining squircle, crest, check, plumb | SVG render call | Scalable 100x100 graphic asset | Vector scales losslessly across viewports | `karigaar_app_icon_logo` |

---

## 6. Edge Cases & Observed Behavioral Constraints

| # | Feature / Screen | Input / Trigger Condition | Observed UI / System Behavior | Architectural Implication |
|---|:---|:---|:---|:---|
| 1 | `karigaar_partner_job_radar` | Dispatch timer reaches `0s` without partner response | Card opacity drops to 40%, interaction disabled, button label flips to "Expired" | Dispatch engine must cascade to next nearby partner immediately upon timeout. |
| 2 | `whatsapp_otp_verification_modal` | User pastes formatted string (e.g. `583-291` or `583291 `) | Regex strip removes non-digits, slices to 6 chars, populates boxes, focuses 6th box | Frontend must sanitize input on paste to prevent invalid characters. |
| 3 | `whatsapp_otp_verification_modal` | WhatsApp OTP fails to arrive within 42 seconds | Timer reaches `00:00`, "Resend OTP" button unlocks; "Send via SMS" remains available | Dual-rail SMS fallback is mandatory for areas with intermittent mobile data. |
| 4 | `partner_active_job_wallet` | Partner adds expensive replacement part (e.g. `+₹380 MCB`) | Part is itemized, total customer payable recalculates to `₹629`, invoice upload required | Prevents bill shock; customer must approve extra parts before completion OTP. |
| 5 | `active_job_live_tracking` | Customer attempts to start job before artisan arrival | Security Start Code (`4921`) must be verbally given to artisan; artisan enters on device | Two-way handshake guarantees physical presence before liability activates. |
| 6 | `create_account_artisan_registration` | Partner uploads Aadhaar card image | Upload bar shows `72% Auto-verified` progress simulation | Requires OCR/DigiLocker integration for automated name and KYC matching. |
| 7 | `karigaar_partner_job_radar` | Partner toggles duty button while receiving incoming dispatch | Status flips from "Active" to "Paused" with red error container | System must clarify whether existing active dispatches cancel or remain pending. |
| 8 | `service_details_custom_quote` | Customer selects "Fastest: Today, 45m" arrival slot | Sticky dock recalculates with 45m estimate tag and triggers immediate radar broadcast | Requires sufficient active partner density in the target pin code. |
| 9 | `super_admin_portal` | Admin triggers emergency surge broadcast | Button animates to "Broadcasting..." then "Broadcast Sent to 24 Artisans" | WhatsApp Business API template approvals and throughput limits must be budgeted. |
| 10 | `skeleton_loading_radar_sync` | Low bandwidth or delayed WebSocket connection | Sticky connection bar displays rotating spinner with "WhatsApp Gateway Synced 99.8%" | Prevents user drop-off during radar scanning by maintaining transparent connection telemetry. |

---

## 7. Cross-Cutting Architectural Implications for Phase 1

1. **Single App vs Dual Apps**:
   - The UI designs feature a unified authentication gateway (`login_whatsapp_onboarding`) with an integrated role switch (`Homeowner` vs `Karigaar`), but distinctly separated bottom navigation bars (`mobile_tab` for customers vs `karigaar_partner_tab` for partners).
   - *Recommendation*: A single unified Flutter application with role-based routing or two standalone Flutter apps sharing a core design token package.
2. **Dual Engagement Paths**:
   - Path A (Direct Contact) relies on phone/WhatsApp links without platform transaction take-rate.
   - Path B (Structured Booking) drives platform revenue through the ₹29 safety shield fee and merchant commission.
   - *Implication*: Founder must establish rules on direct contact number masking vs open contact disclosure.
3. **State Machine & OTP Handshake**:
   - Requires two distinct OTP milestones:
     1. **Start OTP (`4921`)**: Generated on customer screen, entered by partner on arrival.
     2. **Completion OTP**: Generated upon completion and invoice tally, entered by partner to collect payment.
4. **WhatsApp Business API Infrastructure**:
   - WhatsApp is deeply embedded in auth, notifications, radar alerts, invoice slips, and CSAT collection. A robust WhatsApp Business BSP (e.g. Gupshup, Wati, Twilio) is essential from Day 1.

---
*Report generated strictly from inspection of `c:\Users\asimf\Downloads\stitch_karigaar_app_ui\stitch_karigaar_app_ui`.*
