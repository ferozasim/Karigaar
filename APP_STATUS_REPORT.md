# Karigaar System — Comprehensive Operational Status Report

**Generated**: 2026-11-12
**Workspace**: `c:\Users\asimf\OneDrive\Desktop\Karigaar_app`
**Current Branch**: `feat/T-01-multi-district-corridor`
**Pilot Regional Corridor**: 7 Regional Districts (Nanded Primary Hub `431601`–`431606`, Parbhani `431401`, Latur `413512`, Hingoli `431513`, Chhatrapati Sambhajinagar `431001`, Nagpur `440001`, Nizamabad `503001`)
**Launch Trades**: 10 Guild Trades (`Electrician`, `Plumber`, `Carpenter`, `Mason / Gawandi`, `Painter`, `AC & Refrigeration`, `Appliance Repair`, `Welder & Fabricator`, `Pest Control`, `Deep Cleaning`)

---

## 1. Ticket T-01: Multi-District Regional Corridor Implementation

### 1.1 Specification & Architectural Overview
Ticket **T-01** extends the Karigaar hyperlocal pilot from a single-city scope (Nanded) into an interconnected 7-district regional corridor spanning Marathwada, Vidarbha, and Northern Telangana borderlands:
1. **Nanded (Primary Hub)**: 10 Localities (`Anand Nagar`, `Vazirabad & Sarafa`, `CIDCO New Nanded`, `Taroda Naka & Taroda BK`, `Shivaji Nagar`, `Workshop & MIDC`, `Airport Road & Maltekdi`, `Old Nanded & Station Road`, `Dhanegaon`, `Sneha Nagar`).
2. **Parbhani**: 4 Localities (`Station Road & Subhash Road`, `Nanal Peth & Shivaji Chowk`, `Vasant Nagar & Jintur Road`, `Khadkali & Karegaon Road`).
3. **Latur**: 4 Localities (`Ausa Road & Signal Camp`, `Gandhi Chowk & Main Market`, `MIDC & Barshi Road`, `Prakash Nagar & Ring Road`).
4. **Hingoli**: 3 Localities (`Akola Bypass & Risala Bazar`, `Paltan & Gandhi Chowk`, `Kalamnuri Road & MIDC`).
5. **Chhatrapati Sambhajinagar (Aurangabad)**: 5 Localities (`Cidco Cannaught & Jalna Road`, `Kranti Chowk & Station Road`, `Waluj MIDC & Industrial Hub`, `Samarth Nagar & Nirala Bazar`, `Beed Bypass & Seven Hills`).
6. **Nagpur**: 5 Localities (`Dharampeth & Ramdaspeth`, `Sadar & Civil Lines`, `Pratap Nagar & Ring Road`, `Sitabuldi & Variety Square`, `MIDC Butibori & Hingna Road`).
7. **Nizamabad (Telangana)**: 4 Localities (`Khaleelwadi & Tilak Road`, `Station Road & Gandhi Chowk`, `Subhash Nagar & Armoor Road`, `Madhav Nagar & Hyderabad Road`).

### 1.2 Implemented Artifacts & State Plumbing
- **Corridor Configuration Data**:
  - `config/regional_districts.json` (canonical source)
  - `apps/mobile_app/assets/data/regional_districts.json` (bundled Flutter asset)
- **Data Access & Modeling (`lib/core/config/app_data_service.dart`)**:
  - `AppDataService.loadRegionalDistricts()`: Asynchronously decodes `assets/data/regional_districts.json` with in-memory 7-district corridor fallback.
  - `AppDataService.getArtisansForDistrict(String cityId)`: Dispatches localized verified master artisan rosters for all 7 corridor districts (`dist_parbhani`, `dist_latur`, `dist_hingoli`, `dist_aurangabad`, `dist_nagpur`, `dist_nizamabad`, `city_nanded_01`).
  - `AppDataService.getAllSampleArtisans()`: Aggregates complete multi-district artisan pool for global lookup via `artisanByIdProvider`.
- **Riverpod State Management (`lib/core/providers/app_providers.dart`)**:
  - `regionalDistrictsProvider`: `FutureProvider<List<CityConfigModel>>` serving parsed regional corridor districts.
  - `selectedDistrictProvider`: `StateProvider<CityConfigModel>` defaulting to Nanded primary hub.
  - `topArtisansProvider`: Localized roster dynamically derived from `ref.watch(selectedDistrictProvider)`.
- **UI Components**:
  - `LocalitySelectorSheet` (`lib/features/shared/widgets/locality_selector_sheet.dart`): Added horizontal district pill selector above locality search. Switching district dynamically updates `selectedDistrictProvider`, updates the locality list, and automatically selects the first locality of that district.
  - `CustomerHomeScreen` (`lib/features/customer/home/customer_home_screen.dart`): Header chip dynamically displays current district name and active locality, refreshing the top artisans feed on district change.

---

## 2. Adversarial Stress Suite & Hardening Resolutions

### 2.1 Viewport & Extreme Font Scaling (1.5x & 2.0x TextScaler)
- **`CustomerHomeScreen` Emergency Assist Banner**:
  - Replaced rigid side-by-side Row with dynamic responsive breakpoint: triggers stacked layout when `textScaler.scale(1.0) >= 1.4`, preventing a 12px `RenderFlex` overflow at 2.0x font scaling.
- **`CustomerHomeScreen` 10-Trade Grid Items**:
  - Trade title and Marathi subtitles inside fixed `mainAxisExtent: 88` grid cells wrapped in `Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(...)))`, preventing 1px and 13px bottom overflows at 1.5x and 2.0x text scaling.
- **`CustomerBookingsScreen` Cards**:
  - Replaced rigid `Row` headers and footers with `Wrap(alignment: WrapAlignment.spaceBetween, spacing: 8, runSpacing: 8)`, eliminating a 28px overflow when font scale is doubled.
- **`ArtisanActiveJobScreen` Ultra-Compact Viewport (320x568)**:
  - Replaced nested `Row` inside `_buildGuildWalletSection` with `Wrap` and `Flexible(child: Text('HDFC Bank •••• 2104', overflow: TextOverflow.ellipsis))`, eliminating a 19px right overflow.
- **`ArtisanJobRadarScreen` Top Bar**:
  - Wrapped `ModeSwitcherPill(compact: true)` inside `ConstrainedBox(constraints: BoxConstraints(maxWidth: 136))` with `FittedBox` to prevent header compression on 320px screens.

### 2.2 Riverpod Lifecycle & Timer Invariants
- **`ArtisanJobRadarScreen` Timer Leak & Disposal StateError**:
  - Calling `ref.read` during `ConsumerState.dispose()` throws `Bad state: Cannot use "ref" after the widget was disposed.`
  - Calling `stopTimer()` which mutates `state = ...` during unmount throws `Tried to modify a provider while the widget tree was building.`
  - **Resolution**: Added `cancelTimer()` method in `RadarCountdownNotifier` that cancels `_timer` without mutating `state`, converted `radarCountdownProvider` to `autoDispose`, cached `_radarNotifier` reference in `initState`, and called `_radarNotifier?.cancelTimer()` cleanly in `dispose()`.

### 2.3 Form Validation, SnackBars & Widget Finder Hardening
- **`ArtisanRegistrationScreen` Referral Code Toggle**:
  - Initialized `_showReferralInput = false` (closed by default) so tapping the toggle expands the accordion and reveals the "Apply" CTA.
- **`ArtisanRegistrationScreen` Step 3 Validation SnackBar Queueing**:
  - `ScaffoldMessenger.of(context).hideCurrentSnackBar()` invoked before showing new validation messages and on step transition, preventing stale queued messages from masking step-specific validation SnackBars.
- **`ArtisanRegistrationScreen` Payout Section Title**:
  - Restored `'Instant Guild Direct Payout'` title to match Phase 1 and 2 specifications.
- **`LoginScreen` Title Finder Consistency**:
  - Maintained `'Artisan Guild Portal'` role title when switched to Karigaar mode.
- **`OtpVerificationScreen` RichText Finder Compatibility**:
  - Replaced raw `RichText` with `Text.rich(TextSpan(...))` so Flutter's `_TextContainingWidgetFinder` (`find.textContaining('9822998877')`) correctly locates the widget.
- **`LocalitySelectorSheet` ListView CacheExtent Deprecation**:
  - Removed deprecated `cacheExtent: 1500` parameter.

---

## 3. Operational Screen & Route Inventory (`apps/mobile_app`)

All **12 screens** and shared Stitch UI components are implemented, wired into `GoRouter` (`lib/core/router/app_router.dart`), and verified on standard, narrow (`360x800`), and ultra-compact (`320x568`) mobile viewports under `AppTheme.lightTheme`:

| # | Screen / Widget | Route / Path | Operational Status | Key Verified Capabilities |
|---|---|---|---|---|
| 1 | `LoginScreen` | `/login` | **100% Working** | Official `KarigaarBrandLogo`, `ModeSwitcherPill`, WhatsApp login CTA, link to `/artisan/register` in Karigaar mode |
| 2 | `OtpVerificationScreen` | `/otp-verify` | **100% Working** | 4-digit Pinput verification, 42s resend timer, SMS fallback, role-based navigation |
| 3 | `ArtisanRegistrationScreen` | `/artisan/register` | **100% Working** | 10-trade selector, English/हिंदी toggle, 7-district regional selector, Aadhaar KYC scan card, Tools & Safety Kit audit toggle, UPI Penny-Drop payout setup, `GUILD500` referral code accordion |
| 4 | `CustomerHomeScreen` | `/customer/home` | **100% Working** | `KarigaarBrandLogo`, 7-district regional corridor selector, quick trade search, 25-min emergency banner (responsive to 2.0x font scaling), 10-trade grid, `KarigaarRadarSyncSkeleton` loading state, wired bottom navigation |
| 5 | `ServiceScopingScreen` | `/customer/service/:tradeId` | **100% Working** | Issue chips, photo attachment toggle, dynamic inspection + labor estimate, ₹25,000 Guild Shield, creates live booking |
| 6 | `ArtisanProfileScreen` | `/customer/artisan/:artisanId` | **100% Working** | Master credentials, Cleanliness & Sawdust scorecard, Path A direct Call/WhatsApp intents, Path B booking CTA, safe multi-district fallback for unknown IDs |
| 7 | `LiveTrackingScreen` | `/customer/active-tracking/:bookingId` | **100% Working** | Custom route map painter, Doorstep Start OTP (`4921`), dynamic 5-stage milestone stepper synchronized with `BookingStatus`, in-app chat modal |
| 8 | `CustomerBookingsScreen` | `/customer/bookings` | **100% Working** | Active dispatch tracking card + historical bookings with status filter tabs (`All`, `En-Route`, `Upcoming`, `Completed`), wrap-responsive on font scaling |
| 9 | `CustomerMessagesScreen` | `/customer/messages` | **100% Working** | Multi-artisan thread switcher, privacy number-masking banner, interactive message composer, gated society quick-reply chips |
| 10 | `CustomerProfileScreen` | `/customer/profile` | **100% Working** | Homeowner identity card, saved regional corridor chip switcher, UPI AutoPay & WhatsApp alert toggles, emergency SOS contact, portal switcher |
| 11 | `ArtisanJobRadarScreen` | `/artisan/radar` | **100% Working** | Duty status toggle, 45s countdown ring with leak-free autoDispose notifier, regional job broadcast card, masked customer inquiry sheet, one-tap job claim, compact `ModeSwitcherPill` |
| 12 | `ArtisanActiveJobScreen` | `/artisan/active-job/:bookingId` | **100% Working** | Live repair stopwatch, Start OTP (`4921`) handshake synced to `activeBookingProvider`, dynamic spare parts bill builder, Completion PIN (`7294`) settlement crediting `artisanWalletBalanceProvider`, zero-balance IMPS withdrawal guard, 320px wrap layout |

### 3.1 Ticket T-03: Unified Microservice REST Client & Mock Backend Engine
- Implemented `KarigaarApiService` (`lib/core/services/api_service.dart`) adhering to `PROJECT.md` Section 5 Interface Contracts:
  1. **WhatsApp Authentication**: `/api/v1/auth/whatsapp/otp/request` & `verify` with 42s cooldown and phone number validation.
  2. **Masked Telephony Bridge**: `/api/v1/telephony/bridge-call` generating virtual proxy bridge without raw phone number leakage.
  3. **Partner Job Acceptance**: `/api/v1/dispatch/jobs/:id/accept` transitioning job to `ARTISAN_DISPATCHED`.
  4. **Doorstep Security Handshake**: `/api/v1/bookings/:id/start-job` validating customer Start Code `4921` to trigger stopwatch.
  5. **Doorstep Timeout & Denial**: `/api/v1/bookings/:id/doorstep-access-denied` enforcing >=15 min dwell and capturing ₹99 transit fee.
  6. **Decoupled Bill Submission**: `/api/v1/bookings/:id/submit-invoice` calculating 2% parts surcharge and 18% GST.
  7. **Escrow Completion Handshake**: `/api/v1/bookings/:id/verify-completion` releasing escrow funds upon OTP `7294`.
  8. **Instant IMPS Payout**: `/api/v1/wallet/withdraw` strictly enforcing the ₹2,000 rolling security reserve invariant.
- Verified with 14 isolated contract unit tests in `test/unit/api_service_test.dart` (100% passing).

---

## 4. Super Admin Web Console (`apps/admin_web`)

- **Live URL**: `http://localhost:3000`
- **Status**: **100% Working (Ticket T-02 Completed)**
- **Regional Corridor Dashboard Capabilities**:
  - **7-District Corridor Filter Bar**: Quick switching between `All Corridor` and specific regional districts (`Nanded`, `Parbhani`, `Latur`, `Hingoli`, `Sambhajinagar`, `Nagpur`, `Nizamabad`) with active hub count indicators.
  - **Dynamic Live Ops & 2x2 Bento KPIs**: Real-time GMV, completed jobs, turnaround times, active dispatches, and online artisans tailored dynamically to the selected district or aggregated corridor view.
  - **Hyperlocal Surge Heatmap**: Displays active surge multipliers (1.1x–1.4x) and demand statuses for localized trade corridors across Maharashtra and Telangana.
  - **Priority Guild KYC Verification Queue**: Lists pending artisan credential submissions across all 7 districts with district badges, priority SLA tags, Aadhaar/Police verification documents, and interactive 1-click Approve/Review actions.
  - **WhatsApp Outbound Surge Trigger**: Context-aware outbound emergency surge broadcast targeted to the active district.
- **Code Quality & Verification**:
  - `next lint`: **✔ No ESLint warnings or errors**.
  - `npm test`: **8 / 8 foundation deep tests passing (100% PASS RATE)**.
  - `next build`: Generates static export production build cleanly.

---

## 5. Quality, Static Analysis & Automated Test Suite Verification

### 5.1 Verification Summary
- **Flutter Automated Tests (`apps/mobile_app`)**: **150 / 150 tests passing (100% PASS RATE)** across all 17 test suites:
  1. `test/unit/booking_model_stress_test.dart` (18 tests)
  2. `test/unit/booking_state_machine_test.dart` (7 tests)
  3. `test/unit/city_config_test.dart` (3 tests)
  4. `test/unit/contact_intent_service_test.dart` (5 tests)
  5. `test/unit/launch_trades_test.dart` (4 tests)
  6. `test/widget/all_screens_theme_layout_test.dart` (8 tests)
  7. `test/widget/artisan_active_job_wallet_test.dart` (6 tests)
  8. `test/widget/artisan_profile_screen_test.dart` (7 tests)
  9. `test/widget/locality_selector_sheet_test.dart` (5 tests)
  10. `test/widget/locality_selector_stress_test.dart` (12 tests)
  11. `test/widget/mode_switcher_pill_test.dart` (3 tests)
  12. `test/widget/phase1_workflows_stress_test.dart` (6 tests)
  13. `test/widget/phase2_adversarial_stress_test.dart` (32 tests — adversarial viewports 320x568/360x800/390x844, 1.5x/2.0x font scaling, registration form validation)
  14. `test/widget/phase2_workflows_empirical_challenger_test.dart` (4 comprehensive multi-screen workflow tests)
  15. `test/unit/multi_district_corridor_empirical_test.dart` (8 tests — reactive district switching & regional fallback)
  16. `test/widget/multi_district_corridor_widget_test.dart` (8 tests — 7-district step-by-step chip selection without overflow)
  17. `test/unit/api_service_test.dart` (14 tests — WhatsApp OTP, masked telephony, start OTP, doorstep denial, decoupled invoicing, and IMPS reserve)
- **Static Analysis (`apps/mobile_app`)**: `flutter analyze` reports **No issues found! (0 errors, 0 warnings, 0 infos)**.
- **Admin Portal Tests (`apps/admin_web`)**: `npm test` reports **8 / 8 PASSED (0 FAILED)**.
- **Admin Portal Linter (`apps/admin_web`)**: `next lint` reports **✔ No ESLint warnings or errors**.

### 5.2 Workspace Rules Compliance (`.agents/rules/flutter_layout_rules.md`)
1. **Button Theme Sizes**: Global `AppTheme` enforces finite minimum sizes (`Size(64, 52)` and `Size(64, 48)`). No `Size.fromHeight` or `double.infinity` width in themes.
2. **Widget Test Theme Mounting**: All widget tests mount with `theme: AppTheme.lightTheme` and verify `expect(tester.takeException(), isNull)`.
3. **Button Icon Labels**: No redundant `Flexible`/`Expanded` wrappers on `label:` of `*.icon(...)` buttons.
