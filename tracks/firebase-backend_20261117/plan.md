# Implementation Plan: Dual-Mode Firebase (`karigaar-ba812`) + Local Fallback Repositories

**Track ID**: `firebase-backend_20261117`  
**Created**: 2026-11-17  
**Status**: pending  
**Branch**: `feat/T-11-firebase-firestore-backend`  

---

## Overview

Implement a production-grade dual-mode repository architecture for Karigaar. All data access operations across `users`, `artisans`, `bookings`, `mandates`, and `wallets` will be mediated through repository interfaces, supporting both Cloud Firestore (`karigaar-ba812`) and zero-key local in-memory fallback.

---

## Phase 1: Interface Contracts & In-Memory Fallback Repositories

### Tasks
- [ ] **Task 1.1**: Define abstract repository interfaces (`IUserRepository`, `IArtisanRepository`, `IBookingRepository`, `IMandateRepository`, `IWalletRepository`) under `lib/core/repositories/interfaces/`
- [ ] **Task 1.2**: Implement `InMemoryUserRepository` and `InMemoryArtisanRepository` seeded with 7-district regional corridor craftsmen
- [ ] **Task 1.3**: Implement `InMemoryBookingRepository` with live reactive broadcast streams for status transitions
- [ ] **Task 1.4**: Implement `InMemoryMandateRepository` (UPI AutoPay hold/capture/release) and `InMemoryWalletRepository` (paise-accurate balances, ₹2,000 reserve, settlement ledger)
- [ ] **Task 1.5**: Write unit tests for all 5 in-memory repositories in `test/unit/t11_local_repositories_test.dart`

### Verification
- [ ] **Verify 1.1**: All 5 in-memory repositories pass CRUD, reactive streams, and error assertions offline

---

## Phase 2: Dual-Mode Dependency Injection & Provider Wiring

### Tasks
- [ ] **Task 2.1**: Create `lib/core/providers/repository_providers.dart` exposing `isFirebaseLiveProvider` and repository DI providers
- [ ] **Task 2.2**: Wire `app_providers.dart` state notifiers to consume repositories instead of static sample data
- [ ] **Task 2.3**: Implement `localRepositoryOverrides` helper for effortless widget testing with custom seed state
- [ ] **Task 2.4**: Run widget test regression check across existing 38 test suites

### Verification
- [ ] **Verify 2.1**: Existing 349 tests execute with zero regression using repository layer

---

## Phase 3: Cloud Firestore Adapters (`karigaar-ba812`) & Schema Verification

### Tasks
- [ ] **Task 3.1**: Create Firestore serialization schemas matching collections in `firestore.rules`
- [ ] **Task 3.2**: Implement `FirestoreUserRepository`, `FirestoreArtisanRepository`, `FirestoreBookingRepository`, `FirestoreMandateRepository`, and `FirestoreWalletRepository`
- [ ] **Task 3.3**: Add graceful fallback handler: if Firestore throws unauthenticated/unreachable, fallback seamlessly to in-memory store
- [ ] **Task 3.4**: Write schema contract tests in `test/unit/t11_firestore_schema_test.dart`

### Verification
- [ ] **Verify 3.1**: Schema tests validate 100% compliance with `firestore.rules` and `storage.rules`

---

## Phase 4: Final Quality Gates & Documentation

### Tasks
- [ ] **Task 4.1**: Execute `flutter analyze` on `apps/mobile_app` asserting 0 errors, 0 warnings
- [ ] **Task 4.2**: Execute complete `flutter test` test suite asserting all tests pass
- [ ] **Task 4.3**: Update `APP_STATUS_REPORT.md` and `PROJECT.md` with Ticket T-11 completion metrics
- [ ] **Task 4.4**: Prepare pull request for `feat/T-11-firebase-firestore-backend`

### Verification
- [ ] **Verify 4.1**: Clean compilation, zero lint issues, git status clean

---

## Checkpoints

| Phase | Checkpoint SHA | Date | Status |
|---|---|---|---|
| Phase 1: In-Memory Repositories | | | pending |
| Phase 2: Provider Wiring & Regressions | | | pending |
| Phase 3: Firestore Cloud Adapters | | | pending |
| Phase 4: Final Verification & PR | | | pending |
