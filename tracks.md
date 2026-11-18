# Track Registry

## Upcoming Tracks

| Track ID | Type | Status | Phase | Dependencies | Scope / Ticket |
|---|---|---|---|---|---|
| [cloud-webhooks_20261117](tracks/cloud-webhooks_20261117/) | feature | merged | 3/3 | PR #7, `b6981dc` | Ticket T-12: Firebase Functions v2 gateways for WhatsApp, Razorpay callbacks, and masked telephony status |
| [warranty-disputes_20261117](tracks/warranty-disputes_20261117/) | feature | implementation and checks complete; push pending | 2/3 | `cloud-webhooks_20261117` | Ticket T-13: 30% reserve calculation, completed-booking CSAT and warranty intake, admin arbitration prototype; server persistence pending |

## Completed Tracks (Historical Milestone Baselines)

| Track ID | Type | Completed | Duration | Baseline Commit / PR | Summary |
|---|---|---|---|---|---|
| `corridor-expansion_20261114` | feature | 2026-11-14 | 1 day | `c67f5e7` / `836a47a` | Ticket T-01: 7-district regional corridor & localized artisan rosters |
| `admin-corridor-filter_20261114` | feature | 2026-11-14 | 1 day | `eaea81b` | Ticket T-02: Super Admin regional corridor filter & dynamic KPIs |
| `rest-mock-contracts_20261114` | feature | 2026-11-14 | 1 day | `b05511c` | Ticket T-03: Unified microservice REST client engine |
| `telemetry-geofence_20261114` | feature | 2026-11-14 | 1 day | `9fde829` | Ticket T-04: Live geolocation & 200m doorstep arrival geofencing |
| `payment-escrow_20261115` | feature | 2026-11-15 | 1 day | `57a7f1d` | Ticket T-05: UPI ₹99 mandate pre-auth, doorstep denial, IMPS reserve |
| `whatsapp-telephony_20261115` | feature | 2026-11-15 | 1 day | `459bcaf` / PR #1 | Ticket T-06: Meta WhatsApp Cloud API v21.0 & masked virtual DID proxy |
| `radar-broadcast_20261115` | feature | 2026-11-15 | 1 day | `a55f503` / PR #2 | Ticket T-07: Partner dispatch radar 45s broadcast & 2km→6km auto-cascade |
| `onboarding-scoping_20261116` | feature | 2026-11-16 | 1 day | `78cb061` / PR #3 | Ticket T-08: Pre-login Guild Gate, 15s audio memo & arrival slot picker |
| `role-isolation-monetization_20261116` | feature | 2026-11-16 | 1 day | `4cac530` / PR #4 | Ticket T-09: Strict UI role guards, Path A monetization, Guild Elite 5% floor |
| `partner-profile-wallet_20261117` | feature | 2026-11-17 | 1 day | `d96c914` / PR #5 | Ticket T-10: Karigaar Partner Profile, Standalone Wallet & 3-Tab Bottom Nav |
| `firebase-backend_20261117` | feature | 2026-11-18 | 1 day | `89759ad` | Ticket T-11: dual-mode Firestore/local repositories, graceful failover, and Firestore mandate/wallet-ledger rules |
