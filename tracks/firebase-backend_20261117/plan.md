# Implementation Plan: Dual-Mode Firebase (`karigaar-ba812`) + Local Fallback Repositories

**Track ID**: `firebase-backend_20261117`  
**Created**: 2026-11-17  
**Status**: complete — delivered on `feat/T-11-firebase-firestore-backend`
**Branch**: `feat/T-11-firebase-firestore-backend`  

---

## Overview

Implement a production-grade dual-mode repository architecture for Karigaar. All data access operations across `users`, `artisans`, `bookings`, `mandates`, and `wallets` will be mediated through repository interfaces, supporting both Cloud Firestore (`karigaar-ba812`) and zero-key local in-memory fallback.

---

## Phase 1: Interface Contracts & In-Memory Fallback Repositories

### Tasks
- [x] **Task 1.1**: Define abstract repository interfaces (`IUserRepository`, `IArtisanRepository`, `IBookingRepository`, `IMandateRepository`, `IWalletRepository`) under `lib/core/repositories/interfaces/`
- [x] **Task 1.2**: Implement `InMemoryUserRepository` and `InMemoryArtisanRepository` seeded with regional corridor craftsmen
- [x] **Task 1.3**: Implement `InMemoryBookingRepository` with live reactive broadcast streams for status transitions
- [x] **Task 1.4**: Implement `InMemoryMandateRepository` (UPI AutoPay hold/capture/release) and `InMemoryWalletRepository` (paise-accurate balances, ₹2,000 reserve, settlement ledger)
- [x] **Task 1.5**: Write unit tests for all 5 in-memory repositories in `test/unit/t11_local_repositories_test.dart`

### Verification
- [x] **Verify 1.1**: All 5 in-memory repositories pass CRUD, reactive streams, and error assertions offline

---

## Phase 2: Dual-Mode Dependency Injection & Provider Wiring

### Tasks
- [x] **Task 2.1**: Create `lib/core/providers/repository_providers.dart` exposing `isFirebaseLiveProvider` and repository DI providers
- [x] **Task 2.2**: Wire directory profile updates and active booking workflow persistence through the repositories while preserving existing UI state APIs
- [x] **Task 2.3**: Implement `localRepositoryOverride` helper for deterministic widget testing with custom seed state
- [x] **Task 2.4**: Run widget test regression check across the complete mobile suite

### Verification
- [x] **Verify 2.1**: 360 mobile tests execute with zero regression using the repository layer

---

## Phase 3: Cloud Firestore Adapters (`karigaar-ba812`) & Schema Verification

### Tasks
- [x] **Task 3.1**: Create Firestore serialization schemas matching collections in `firestore.rules`
- [x] **Task 3.2**: Implement `FirestoreUserRepository`, `FirestoreArtisanRepository`, `FirestoreBookingRepository`, `FirestoreMandateRepository`, and `FirestoreWalletRepository`
- [x] **Task 3.3**: Add graceful fallback handler: if Firestore throws unauthenticated/unreachable, fallback seamlessly to in-memory store
- [x] **Task 3.4**: Write schema contract tests in `test/unit/t11_firestore_schema_test.dart`

### Verification
- [x] **Verify 3.1**: Schema tests validate Firestore document ownership fields and stable collection identities; storage media integration is outside the repository scope

---

## Phase 4: Final Quality Gates & Documentation

### Tasks
- [x] **Task 4.1**: Execute `flutter analyze` on `apps/mobile_app` asserting 0 errors, 0 warnings
- [x] **Task 4.2**: Execute complete `flutter test` test suite asserting all tests pass
- [x] **Task 4.3**: Update `APP_STATUS_REPORT.md` and `PROJECT.md` with Ticket T-11 completion metrics
- [x] **Task 4.4**: Prepare the verified feature-branch delivery; pull-request creation remains optional

### Verification
- [x] **Verify 4.1**: `flutter analyze` is clean; all 360 mobile tests, 9/9 admin foundation tests, and admin lint pass before delivery

---

## Checkpoints

| Phase | Checkpoint SHA | Date | Status |
|---|---|---|---|
| Phase 1: In-Memory Repositories | `9fa4b23` | 2026-11-18 | complete |
| Phase 2: Provider Wiring & Regressions | `9fa4b23` | 2026-11-18 | complete |
| Phase 3: Firestore Cloud Adapters | `9fa4b23` | 2026-11-18 | complete |
| Phase 4: Final Verification & PR | `9fa4b23` | 2026-11-18 | complete |
