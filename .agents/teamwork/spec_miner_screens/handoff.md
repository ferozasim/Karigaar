# Handoff Report — Spec Miner Screens & Design Tokens

**Agent**: `teamwork_spec_miner`  
**Working Directory**: `c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\spec_miner_screens`  
**Recipient**: `3d3e2c66-2a06-4e67-9deb-5bda74c8c14f` (Orchestrator)  
**Milestone**: Phase 0 Specification Mining — UI Screens & Design Tokens  
**Handoff Type**: Hard (Task Complete)

---

### 1. Observation

Direct file inspection of `c:\Users\asimf\Downloads\stitch_karigaar_app_ui\stitch_karigaar_app_ui` via `find_by_name`, `list_dir`, and `view_file` revealed 15 subdirectories containing 13 HTML prototypes, 1 SVG asset, 12 screen preview PNGs, and 1 system design document (`DESIGN.md`).

Key direct observations:
1. **Design Tokens (`karigaar_artisan_trust/DESIGN.md`, lines 1–129)**:
   - System Name: *"Karigaar Artisan Trust"*.
   - Palette Tokens: Deep Guild Slate (`#0F172A` / `#1E293B`, YAML `primary: '#000000'`), Artisan Amber (`#D97706` / `#F59E0B`, YAML `secondary: '#904d00'`, container `#fe932c`), Verified Emerald (`#059669` / `#10B981`, YAML `tertiary: '#000000'`, container `#002114`, text `#069669`), Surface Base (`#F8FAFC` / `#f8f9ff`), Surface Raised (`#FFFFFF`), Border Subtle (`#E2E8F0`).
   - Typography Tokens: Headings in `Plus Jakarta Sans` (display-lg: 32px/800, headline-lg: 24px/700, headline-md: 20px/700, headline-sm: 18px/600, body-md: 14px/400); tabular data/prices in `Inter` (`numeric-price`: 22px/700, `label-lg`: 14px/600, `label-md`: 12px/600, `label-sm`: 11px/700).
   - Layout & Elevation: 390px mobile viewport baseline, 20px (`1.25rem`) canvas margin, 48px min touch target, Level 0–3 elevation with tinted slate/amber shadows and frosted glass backdrop blur (`12px` to `16px`).
2. **12 Enumerated Screens Analyzed**:
   - `home_discovery`: Customer discovery shell (`mobile_tab`), 8-grid trade categories, emergency 24x7 banner, Karigaar Shield (100% Police Verified, Rate Card Protection, 30-Day Guarantee), top-rated cards (Rajesh Sharma ₹299, Tariq Anwar ₹199), curated seasonal packages (AC Deep Clean ₹599, Electrical Audit ₹799), bottom nav tabs.
   - `service_details_custom_quote`: Customer package builder (`mobile_stack`), multi-issue toggle (MCB Tripping ₹249, Socket Repair ₹149, Fan/Chandelier ₹199, Inverter ₹399), photo preview (`main_mcb_panel.jpg`) & 15s voice memo record, arrival slot picker (Today 45m, Tomorrow, Oct 15, Oct 16; 3 time windows), transparent price tally (`₹199` visit + `₹249` task + `₹29` safety fee = `₹477`), sticky checkout CTA.
   - `active_job_live_tracking`: Customer live monitoring (`mobile_stack`), Job `#KG-8842`, live vector map canvas with multi-color SVG polyline (completed in green, active in amber, planned in slate), moving motorcycle marker (`two_wheeler`) with 14-min ETA, 5-stage milestone stepper (Booking Confirmed -> Dispatched -> On the Way -> Execution -> Sign-off), 4-digit Security Start Code (`4921`), assigned artisan card (Rajesh Kumar), call/chat actions, canned parking/gate chips, ₹10k guild damage protection banner, modal chat drawer.
   - `create_account_artisan_registration`: Partner onboarding Step 1 of 3 (`mobile_stack`), bilingual language toggle (`English` / `हिंदी`), 33.3% progress bar, "Join the Karigaar Guild" (₹42,000/mo avg earnings across NCR & MMR), role switcher (Karigaar vs Customer), 2-column primary trade selector (Electrician, Carpenter, Plumbing, AC, Painter, Masonry), legal name + Aadhaar match, +91 WhatsApp number with instant OTP badge, Gurgaon locality selector, experience tiers (1-3y, 3-5y, 5-10y, 10+ Master), Aadhaar photo upload with 72% simulated auto-verification, WhatsApp dispatcher opt-in, referral code accordion (`GUILD500`), sticky OTP verify CTA.
   - `login_whatsapp_onboarding`: Shared authentication gateway (`mobile_auth`), Karigaar branding, Hindi tagline *"भारत के सबसे भरोसेमंद कारीगर"*, role switch tabs (Homeowner vs Karigaar), dynamic artisan benefit card (0% commission month, trade carousel, Aadhaar KYC, tool insurance, daily payouts), 1-tap WhatsApp login button (emerald green `#069669`), 10-digit mobile entry with SMS fallback, 256-bit encryption / NSDC Partner trust strip, WhatsApp concierge help link (`wa.me/919999999999`).
   - `whatsapp_otp_verification_modal`: Shared OTP verification sheet (`mobile_auth`), backdrop blur, pull handle, WhatsApp branding icon, editable phone display (+91 98104 22910), 6 individual OTP input boxes with auto-advance, backspace retreat, arrow key nav, and clipboard paste handling, 42-second countdown timer, resend button unlocking upon expiry, secondary SMS fallback button, dynamic amber button state on completion, verified encryption stamp.
   - `karigaar_partner_job_radar`: Partner radar hub (`karigaar_partner_tab`), online status pill, active/paused duty toggle, today's metrics (₹1,850 earnings, 3 jobs, 98% acceptance), WhatsApp dual sync banner, high-urgency dispatch alert with 45s animated circular SVG countdown timer (expires to 40% opacity at 0s), emergency short circuit job (₹480 payout, Vikram Mehta, Sector 42, 1.8km), attached photo of tripped Havells MCB & 14s voice memo, direct WhatsApp inquiry link (*"Ask Customer on WhatsApp First"*), Pass / Accept actions, 5-job nearby broadcast feed with filter pills and one-tap claim buttons.
   - `partner_active_job_wallet`: Partner active job & earnings (`karigaar_partner_tab`), Job `#KG-8842` live elapsed timer (`28m 14s`), customer summary (Pooja Sharma, Flat 402, DLF Phase 4), turn-by-turn navigation button, call/WhatsApp connectors, dynamic material & labor bill builder (Base ₹249 + Schneider 32A MCB ₹380 = ₹629 with 18% GST invoice), receipt photo attach, resident completion OTP 4-digit input panel, Gold Guildsman tier progress (42/50 jobs, 84%), Guild Wallet hero card (₹4,620 cleared balance, +₹629 pending, instant IMPS 24/7 zero-fee withdrawal, HDFC Bank linked), recent ledger activity.
   - `karigaar_profile_reviews`: Master craftsman profile (`mobile_stack`), favorite heart toggle & share, Rajesh Kumar Sharma (Master Carpenter, Indiranagar, 4.2km, Available Today), metrics (4.95 stars, 418 reviews, 11+ yrs, 1,240+ completed), triple-screened guild credentials (Govt ID/Police, NSDC Certified, ₹25k Cover, Calibrated Tools), 6 certified skill chips, craftsmanship showcase carousel (Fluted TV Console, Burmese Teak Dining Table, Soft-close Wardrobe), performance scorecard with Punctuality 5.0, Craft 4.9, and **Sawdust & Cleanliness 5.0**, verified customer testimonials (Pooja M., Amit V.), sticky booking dock (₹299/visit + ₹25k warranty, "Book Rajesh Now").
   - `super_admin_portal`: Mobile operations console (`super_admin_mobile`), Admin Guild header with live 99.8% uptime, HQ Ops stream (142 active dispatches, 89 available artisans, 0.2% dispute rate), 2x2 KPI grid (Daily GMV ₹1,84,500, Completed 328 jobs, Guild Queue 18 pending, WA Outbound 1,420 msgs), live surge grid alert (DLF Phase 4 & Cyber City, Surge 1.4x, 6 Electricians needed), job volume mix bar (Electrician 38%, Carpenter 26%, Plumber 20%, Appliance 16%), priority KYC queue with optimistic approval/reject actions (Mohd. Salim approved, Ramesh Verma tool calibration due), WhatsApp emergency surge broadcast tool (notify 24 technicians with ₹250 bonus), automated CSAT tracker (94% 5-star across 1,180 responses).
   - `skeleton_loading_radar_sync`: System loading state (`mobile_stack`), CSS `@keyframes karigaarShimmer` (1.8s sweep over `#E5EEFF` mask), `@keyframes radarSweep` (2.2s pulse from 0.7 to 2.4 scale), staggered JS animation delays, search skeleton, radar pulse sensor placeholder, 8-grid trade skeleton, 2 nearby artisan card skeletons with squircle avatars, floating telemetry connection bar ("Connecting to Karigaar Guild... WhatsApp Gateway Synced 99.8%"), 4-tab bottom nav skeleton.
   - `karigaar_app_icon_logo`: Scalable Vector Graphic (`viewBox="0 0 100 100"`), Deep Guild Slate squircle background (`rx="24"`, `#0F172A`), Artisan Amber hexagonal guild crest (`#F59E0B`, `#1E293B`), Verified Emerald checkmark (`#10B981`), Artisan Amber plumb line and center pivot (`#F59E0B`).
3. **Additional Asset**: `karigaar_artisan_home_services_platform/code.html` establishes the shared responsive authentication wrapper (`min-height: max(884px, 100dvh)`, `overscroll-behavior: none`, safe-area insets).

---

### 2. Logic Chain

1. **Brand & Architectural Consistency (Observations 1 & 2)**:
   - The UI designs enforce a coherent design language across Customer, Partner, and Admin personas using the "Karigaar Artisan Trust" theme.
   - Deep Guild Slate anchors structural authority, Artisan Amber denotes kinetic urgency/ratings, and Verified Emerald denotes trust, KYC, and warranty protection.
2. **Dual Engagement Paths Mapping (Observation 2)**:
   - **Path A (Direct Contact)**: Established via `home_discovery` -> `karigaar_profile_reviews` where direct `tel:` and `wa.me` connectors are provided, alongside transparent visit fees (`₹299`) and ₹25k warranty assurances.
   - **Path B (Structured In-App Booking)**: Established via `service_details_custom_quote` -> `karigaar_partner_job_radar` -> `active_job_live_tracking` -> `partner_active_job_wallet` with end-to-end milestone tracking, two-factor OTP verification (Start Code `4921` + Completion OTP), on-site itemized invoice building, and instant IMPS wallet payouts.
3. **Deep Local Context as Core Differentiator (Observations 1 & 2)**:
   - WhatsApp is not merely a communication channel; it is the platform's core identity layer (1-tap login, dual-sync dispatch, invoice delivery, emergency broadcasts, automated CSAT).
   - Specific Indian pain points are addressed directly in the UI (Aadhaar KYC, Police verification, NSDC trade certification, gate pass security codes, and post-service sawdust cleanup).
4. **Implementation Constraint Adherence**:
   - Strictly Phase 0 specification mining; zero application code, prototype repositories, or database models were modified or created.

---

### 3. Caveats

- **Single vs Separate Apps**: The designs contain a unified auth gateway (`login_whatsapp_onboarding`) with role switching, but completely separate bottom navigation systems (`mobile_tab` vs `karigaar_partner_tab` vs `super_admin_mobile`). The founder must decide whether Customers and Partners reside in one app or separate app store binaries.
- **Direct Contact Disintermediation**: Path A provides direct phone numbers and WhatsApp links. Without phone number masking (e.g. Exotel/Twilio virtual numbers), the platform risks booking disintermediation.
- **Pilot City Scope**: UI references Gurgaon / NCR zones (DLF Phase 4, Cyber City, Sector 48) as the primary active geography, alongside legacy sample references to Bengaluru (Indiranagar, Koramangala) in portfolio cards. Gurgaon is the logical pilot city.

---

### 4. Conclusion

The provided 12 UI screens, DESIGN.md design tokens, and SVG assets provide a comprehensive, production-ready design specification for the Karigaar platform. All UI hierarchies, interactive state machines, data attributes, localized trust signals, and dual workflow journeys have been completely documented in `c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\spec_miner_screens\analysis.md`. The design is fully ready for Founder Phase 0 alignment.

---

### 5. Verification Method

To independently verify this specification analysis:
1. **Inspect Report Artifacts**:
   - View `c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\spec_miner_screens\analysis.md` for exhaustive screen breakdowns, design token tables, and features matrix.
2. **Validate UI Source Prototypes**:
   - Open each `code.html` file in `c:\Users\asimf\Downloads\stitch_karigaar_app_ui\stitch_karigaar_app_ui` in any standard browser to verify visual rendering, layout hierarchy, and micro-interactions.
3. **Verify Zero Implementation Code**:
   - Check workspace git status or directory listings to confirm no application code files (Dart, Flutter, JS, TS) were authored.
