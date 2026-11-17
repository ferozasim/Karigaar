# Track Specification: Dual-Mode Firebase (`karigaar-ba812`) + Local Fallback Repositories

**Track ID**: `firebase-backend_20261117`  
**Related Ticket**: Ticket T-11 (`feat/T-11-firebase-firestore-backend`)  
**Target Project**: Firebase `karigaar-ba812` (`.firebaserc`, `firestore.rules`, `storage.rules`)  

---

## 1. Overview

Ticket **T-11** implements the persistence architecture for Karigaar by delivering a **Dual-Mode Repository Layer** across 5 core business collections (`users`, `artisans`, `bookings`, `mandates`, `wallets`). The system supports:
1. **Live Cloud Mode**: Binds to Firebase project `karigaar-ba812` via Cloud Firestore & Cloud Storage.
2. **Deterministic Offline Fallback Mode**: In-memory repository implementations that allow all 340+ automated Flutter widget/unit tests to run at full speed without network latency or credentials.

---

## 2. Functional Requirements

### FR-1: Core Repository Interfaces
Define abstract interfaces for each core collection:
- `IUserRepository`: `getById`, `save`, `updateRole`, `streamUser`
- `IArtisanRepository`: `getById`, `getByDistrict`, `updateProfile`, `updateRateCard`, `streamArtisans`
- `IBookingRepository`: `createBooking`, `getById`, `updateStatus`, `streamActiveBookings`, `streamArtisanJobs`
- `IMandateRepository`: `createPreAuthMandate`, `getById`, `captureDoorstepFee`, `releaseMandate`
- `IWalletRepository`: `getWalletByArtisanId`, `recordSettlement`, `withdrawImps`, `getLedgerHistory`

- **Acceptance**: All interfaces use strongly-typed models (`ArtisanProfileModel`, `BookingModel`, `WalletSettlementEntry`, `MandateModel`).

### FR-2: In-Memory / Local Fallback Adapters
Implement deterministic in-memory implementations (`InMemoryUserRepository`, `InMemoryArtisanRepository`, `InMemoryBookingRepository`, `InMemoryMandateRepository`, `InMemoryWalletRepository`):
- Seeded with the 7-district regional corridor sample data (`config/regional_districts.json` and `launch_trades.json`).
- Thread-safe, reactive state changes with `StreamController.broadcast()`.
- Supports latency simulation (0ms default for instant test runs).

- **Acceptance**: 100% of repository tests pass completely offline with zero credentials.

### FR-3: Cloud Firestore Adapters (`karigaar-ba812`)
Implement cloud repository adapters that map data models to/from Firestore document schemas:
- Map `/users/{userId}` to user authentication profile and active role.
- Map `/artisans/{artisanId}` to public directory documents with search indexes.
- Map `/bookings/{bookingId}` to active job tickets with status transitions.
- Map `/mandates/{mandateId}` to UPI AutoPay records with idempotency keys.
- Map `/wallets/{artisanId}` to financial balances and sub-collection `/wallets/{artisanId}/ledger/{entryId}`.

- **Acceptance**: Serialization and deserialization matches `firestore.rules` security policies.

### FR-4: Dual-Mode Repository Provider & Runtime Switch
Wire Riverpod providers that supply the appropriate implementation based on runtime environment:
- `isFirebaseLiveProvider`: boolean flag checking for active Firebase app initialization.
- Provide `userRepositoryProvider`, `artisanRepositoryProvider`, `bookingRepositoryProvider`, `mandateRepositoryProvider`, `walletRepositoryProvider`.

- **Acceptance**: Switching modes requires zero changes to UI or business logic widgets.

---

## 3. Non-Functional Requirements

### NFR-1: Zero-Credential Test Execution
- **Target**: Complete test suite must run and pass without requiring `google-services.json` or `GoogleService-Info.plist`.
- **Verification**: `flutter test` executes in CI/clean environment with 100% pass rate.

### NFR-2: Test Performance
- **Target**: Repository unit tests must complete in < 5 seconds total.
- **Verification**: Measure test suite runtime with local in-memory adapters.

### NFR-3: Static Analysis & Clean Architecture
- **Target**: 0 errors, 0 warnings from `flutter analyze`.
- **Verification**: `flutter analyze` runs clean on `apps/mobile_app`.

---

## 4. Acceptance Criteria

- [ ] Repository interfaces defined with clean contract boundaries in `lib/core/repositories/interfaces/`
- [ ] In-memory mock repositories implemented with corridor seed data in `lib/core/repositories/local/`
- [ ] Cloud Firestore repositories implemented matching schema rules in `lib/core/repositories/firestore/`
- [ ] Dependency injection providers wired cleanly in Riverpod (`lib/core/providers/repository_providers.dart`)
- [ ] Comprehensive unit tests verifying CRUD, streaming, and error handling for all repositories
- [ ] Zero regressions across existing 349 mobile tests
- [ ] `flutter analyze` reports 0 issues

---

## 5. Scope

### In Scope
- Repository interfaces and dual implementations (In-Memory + Cloud Firestore)
- Collections: `users`, `artisans`, `bookings`, `mandates`, `wallets`
- Integration with existing Riverpod providers (`app_providers.dart`)
- Comprehensive contract & integration unit tests

### Out of Scope
- Backend webhook endpoints (deferred to Ticket T-12 / `cloud-webhooks_20261117`)
- Admin dispute resolution queue UI (deferred to Ticket T-13 / `warranty-disputes_20261117`)

---

## 6. Dependencies

### Internal
- Data models: `ArtisanProfileModel`, `BookingModel`, `WalletSettlementEntry`, `KarigaarRoleType`
- Seed configurations: `regional_districts.json`, `launch_trades.json`

### External
- Firebase Project: `karigaar-ba812`
- Security rules: `firestore.rules`, `storage.rules`

---

## 7. Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Firestore library initialization failure in CI/tests | High | Default to `InMemoryRepository` whenever Firebase is uninitialized |
| Data model schema divergence between local and cloud | Medium | Use shared `toJson()` / `fromJson()` contract methods verified by schema tests |
| Riverpod provider override complexity in widget tests | Low | Export clean `localRepositoryOverrides` utility for test harnesses |
