# Ticket T-13: Warranty Disputes & CSAT

## Goal

Deliver the customer-facing warranty claim and post-job CSAT flows plus an admin arbitration prototype, grounded in the product rules in `PROJECT.md`.

## Acceptance checklist

- [x] Calculate a 30% warranty reserve contribution from platform labor take-rate.
- [x] Collect 1–5 overall, cleanliness, and sawdust ratings on completed bookings.
- [x] Validate warranty eligibility, exact 30-day window, ₹250 deductible, and ₹10k/₹25k cover ceiling.
- [x] Add admin warranty reserve and CSAT KPIs and claim actions: payout, free rework, reject.
- [x] Add focused mobile unit and widget coverage; run mobile and admin validation (366 Flutter tests, clean `flutter analyze`, 9 admin tests, lint, production build).
- [x] Open the admin build in Chrome and visually verify the warranty KPIs, arbitration actions, and CSAT monitor render.
- [x] Update project and track documentation.
- [ ] Commit and push the verified feature branch.

## Implementation boundary

This delivery is an interactive prototype. Mobile claims/CSAT and admin decisions are held in client-side state; the reserve KPI uses demo ledger values. There is no Firestore or server persistence for these T-13 records yet, so it is not a production claims or accounting ledger.

## Validation

Passed: 366 mobile tests, no Flutter analysis issues, 9 admin tests, admin lint, production build, and a Chrome smoke review at `http://127.0.0.1:3000`.
