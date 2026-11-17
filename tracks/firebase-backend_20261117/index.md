# Track: `firebase-backend_20261117`

- **Title**: Dual-Mode Firebase (`karigaar-ba812`) + Local Fallback Repositories
- **Ticket**: Ticket T-11 (`feat/T-11-firebase-firestore-backend`)
- **Status**: 📋 `pending`
- **Created**: 2026-11-17
- **Phases**: 4 phases / 17 tasks

## Quick Links
- [Specification (spec.md)](spec.md)
- [Implementation Plan (plan.md)](plan.md)
- [Track Metadata (metadata.json)](metadata.json)

## Scope Summary
Wires 5 repository abstractions (`users`, `artisans`, `bookings`, `mandates`, `wallets`) supporting live cloud sync with Firebase project `karigaar-ba812` while providing a 100% deterministic local in-memory fallback for offline test suites.
