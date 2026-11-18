import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/artisan_profile_model.dart';
import 'package:karigaar_app/core/models/booking_model.dart';
import 'package:karigaar_app/core/models/mandate_model.dart';
import 'package:karigaar_app/core/models/user_profile_model.dart';
import 'package:karigaar_app/core/models/user_role.dart';
import 'package:karigaar_app/core/models/wallet_model.dart';
import 'package:karigaar_app/core/models/wallet_settlement_entry.dart';
import 'package:karigaar_app/core/repositories/fallback/fallback_repositories.dart';
import 'package:karigaar_app/core/repositories/interfaces/user_repository.dart';
import 'package:karigaar_app/core/repositories/local/in_memory_repositories.dart';

void main() {
  final now = DateTime.utc(2026, 11, 18);

  UserProfileModel user() => UserProfileModel(
        userId: 'cust_01',
        displayName: 'Asim',
        phone: '+919800000000',
        activeRole: UserRole.customer,
        cityId: 'city_nanded_01',
        createdAt: now,
        updatedAt: now,
      );

  ArtisanProfileModel artisan() => const ArtisanProfileModel(
        artisanId: 'art_01',
        name: 'Ganesh',
        phone: '+919811111111',
        primaryTradeId: 'trade_electrician',
        tradeTitle: 'Electrician',
        yearsExperience: 8,
        rating: 4.9,
        reviewCount: 40,
        distanceKm: 1.2,
        bio: 'Verified artisan',
        inspectionFee: 199,
        cityId: 'city_nanded_01',
        localityId: 'loc_anand_nagar',
      );

  BookingModel booking() => BookingModel(
        bookingId: 'BK_01',
        customerId: 'cust_01',
        customerName: 'Asim',
        customerPhone: '+919800000000',
        assignedArtisanId: 'art_01',
        tradeId: 'trade_electrician',
        tradeName: 'Electrician',
        localityId: 'loc_anand_nagar',
        localityName: 'Anand Nagar',
        address: 'Plot 1',
        status: BookingStatus.assigned,
        createdAt: now,
      );

  test('user repository persists role changes and streams updates', () async {
    final repository = InMemoryUserRepository([user()]);
    final values = <UserProfileModel?>[];
    final subscription = repository.streamUser('cust_01').listen(values.add);
    await Future<void>.delayed(Duration.zero);
    expect(values.single!.activeRole, UserRole.customer);

    await repository.updateRole('cust_01', UserRole.artisan);
    await Future<void>.delayed(Duration.zero);
    expect(values.last!.activeRole, UserRole.artisan);
    await subscription.cancel();
    await repository.dispose();
  });

  test('fallback repository continues locally when its primary is unavailable',
      () async {
    final local = InMemoryUserRepository([user()]);
    final repository =
        FallbackUserRepository(_UnavailableUserRepository(), local);

    expect((await repository.getById('cust_01'))!.displayName, 'Asim');
    await repository.updateRole('cust_01', UserRole.artisan);
    expect((await local.getById('cust_01'))!.activeRole, UserRole.artisan);
    await local.dispose();
  });

  test('artisan repository updates profile and district stream', () async {
    final repository = InMemoryArtisanRepository([artisan()]);
    final values = <List<ArtisanProfileModel>>[];
    final subscription =
        repository.streamArtisans('city_nanded_01').listen(values.add);
    await Future<void>.delayed(Duration.zero);
    expect(values.single.single.inspectionFee, 199);

    await repository.updateRateCard(
      'art_01',
      inspectionFee: 249,
      dailyDihadiRate: 950,
    );
    await Future<void>.delayed(Duration.zero);
    expect(values.last.single.inspectionFee, 249);
    expect(values.last.single.dailyDihadiRate, 950);
    await subscription.cancel();
    await repository.dispose();
  });

  test('booking repository publishes status transitions', () async {
    final repository = InMemoryBookingRepository([booking()]);
    final values = <List<BookingModel>>[];
    final subscription =
        repository.streamArtisanJobs('art_01').listen(values.add);
    await Future<void>.delayed(Duration.zero);
    expect(values.single.single.status, BookingStatus.assigned);

    await repository.updateStatus('BK_01', BookingStatus.workInProgress);
    await Future<void>.delayed(Duration.zero);
    expect(values.last.single.status, BookingStatus.workInProgress);
    await subscription.cancel();
    await repository.dispose();
  });

  test('mandate repository is idempotent and tracks capture/release', () async {
    final repository = InMemoryMandateRepository();
    final mandate = MandateModel(
      mandateId: 'man_01',
      bookingId: 'BK_01',
      customerId: 'cust_01',
      upiVpa: 'asim@okaxis',
      amountPaise: 9900,
      status: UpiMandateStatus.authorized,
      idempotencyKey: 'booking-BK_01-preauth',
      createdAt: now,
      updatedAt: now,
    );
    expect(
        (await repository.createPreAuthMandate(mandate)).mandateId, 'man_01');
    expect(
      (await repository.createPreAuthMandate(mandate.copyWith())).mandateId,
      'man_01',
    );
    expect(
      (await repository.captureDoorstepFee('man_01')).status,
      UpiMandateStatus.captured,
    );
    expect(
      (await repository.releaseMandate('man_01')).status,
      UpiMandateStatus.released,
    );
  });

  test('wallet repository keeps paise precision and the reserve locked',
      () async {
    final repository = InMemoryWalletRepository(
      wallets: [
        WalletModel(
          artisanId: 'art_01',
          availableBalancePaise: 462075,
          reserveBalancePaise: 200000,
          updatedAt: now,
        ),
      ],
    );
    const settlement = WalletSettlementEntry(
      id: 'stl_01',
      bookingId: 'BK_01',
      jobTitle: 'Electrical repair',
      customerLocality: 'Anand Nagar',
      completedAtLabel: 'Just now',
      laborAmount: 100,
      partsPassThrough: 0,
      commissionRate: 0.05,
      commissionAmount: 5,
      netPayout: 95.25,
      isCredit: true,
      isImpsWithdrawal: false,
      statusLabel: 'Settled',
    );
    await repository.recordSettlement('art_01', settlement);
    expect(
      (await repository.getWalletByArtisanId('art_01'))!.availableBalancePaise,
      471600,
    );
    final withdrawal = await repository.withdrawImps(
      'art_01',
      amountPaise: 271600,
      bankReference: 'RRN123',
    );
    expect(withdrawal.isImpsWithdrawal, isTrue);
    expect(
      (await repository.getWalletByArtisanId('art_01'))!.availableBalancePaise,
      200000,
    );
    expect((await repository.getLedgerHistory('art_01')).length, 2);
    await repository.dispose();
  });
}

class _UnavailableUserRepository implements IUserRepository {
  Never _unavailable() => throw StateError('Firestore is unavailable');

  @override
  Future<UserProfileModel?> getById(String userId) async => _unavailable();

  @override
  Future<void> save(UserProfileModel user) async => _unavailable();

  @override
  Stream<UserProfileModel?> streamUser(String userId) => Stream.error(
        StateError('Firestore is unavailable'),
      );

  @override
  Future<void> updateRole(String userId, UserRole role) async => _unavailable();
}
