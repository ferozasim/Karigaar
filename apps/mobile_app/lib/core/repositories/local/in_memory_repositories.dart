import 'dart:async';

import '../../models/artisan_profile_model.dart';
import '../../models/booking_model.dart';
import '../../models/mandate_model.dart';
import '../../models/user_profile_model.dart';
import '../../models/user_role.dart';
import '../../models/wallet_model.dart';
import '../../models/wallet_settlement_entry.dart';
import '../interfaces/artisan_repository.dart';
import '../interfaces/booking_repository.dart';
import '../interfaces/mandate_repository.dart';
import '../interfaces/user_repository.dart';
import '../interfaces/wallet_repository.dart';

/// Offline-first repository implementations used by development and tests.
/// A single isolate serializes Dart mutations, and every mutation publishes a
/// fresh immutable collection snapshot to its broadcast stream.
class InMemoryUserRepository implements IUserRepository {
  InMemoryUserRepository([Iterable<UserProfileModel> seed = const []]) {
    for (final user in seed) {
      _users[user.userId] = user;
    }
  }

  final Map<String, UserProfileModel> _users = {};
  final Map<String, StreamController<UserProfileModel?>> _controllers = {};

  StreamController<UserProfileModel?> _controllerFor(String userId) =>
      _controllers.putIfAbsent(
        userId,
        () => StreamController<UserProfileModel?>.broadcast(),
      );

  @override
  Future<UserProfileModel?> getById(String userId) async => _users[userId];

  @override
  Future<void> save(UserProfileModel user) async {
    _users[user.userId] = user;
    _controllerFor(user.userId).add(user);
  }

  @override
  Stream<UserProfileModel?> streamUser(String userId) async* {
    yield _users[userId];
    yield* _controllerFor(userId).stream;
  }

  @override
  Future<void> updateRole(String userId, UserRole role) async {
    final user = _users[userId];
    if (user == null) throw StateError('User $userId was not found');
    await save(user.copyWith(activeRole: role, updatedAt: DateTime.now()));
  }

  Future<void> dispose() async {
    for (final controller in _controllers.values) {
      await controller.close();
    }
  }
}

class InMemoryArtisanRepository implements IArtisanRepository {
  InMemoryArtisanRepository([Iterable<ArtisanProfileModel> seed = const []]) {
    for (final artisan in seed) {
      _artisans[artisan.artisanId] = artisan;
    }
  }

  final Map<String, ArtisanProfileModel> _artisans = {};
  final StreamController<List<ArtisanProfileModel>> _changes =
      StreamController<List<ArtisanProfileModel>>.broadcast();

  List<ArtisanProfileModel> _forDistrict(String cityId) => _artisans.values
      .where((artisan) => artisan.cityId == cityId)
      .toList(growable: false);

  void _publish(String cityId) => _changes.add(_forDistrict(cityId));

  @override
  Future<ArtisanProfileModel?> getById(String artisanId) async =>
      _artisans[artisanId];

  @override
  Future<List<ArtisanProfileModel>> getByDistrict(String cityId) async =>
      _forDistrict(cityId);

  @override
  Future<void> save(ArtisanProfileModel artisan) async {
    final priorDistrict = _artisans[artisan.artisanId]?.cityId;
    _artisans[artisan.artisanId] = artisan;
    if (priorDistrict != null && priorDistrict != artisan.cityId) {
      _publish(priorDistrict);
    }
    _publish(artisan.cityId);
  }

  @override
  Future<void> updateProfile(ArtisanProfileModel artisan) => save(artisan);

  @override
  Future<void> updateRateCard(
    String artisanId, {
    required int inspectionFee,
    required int dailyDihadiRate,
  }) async {
    final artisan = _artisans[artisanId];
    if (artisan == null) throw StateError('Artisan $artisanId was not found');
    await save(artisan.copyWith(
      inspectionFee: inspectionFee,
      dailyDihadiRate: dailyDihadiRate,
    ));
  }

  @override
  Stream<List<ArtisanProfileModel>> streamArtisans(String cityId) async* {
    yield _forDistrict(cityId);
    yield* _changes.stream.map((_) => _forDistrict(cityId));
  }

  Future<void> dispose() => _changes.close();
}

class InMemoryBookingRepository implements IBookingRepository {
  InMemoryBookingRepository([Iterable<BookingModel> seed = const []]) {
    for (final booking in seed) {
      _bookings[booking.bookingId] = booking;
    }
  }

  final Map<String, BookingModel> _bookings = {};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  void _publish() => _changes.add(null);

  @override
  Future<void> createBooking(BookingModel booking) async {
    if (_bookings.containsKey(booking.bookingId)) {
      throw StateError('Booking ${booking.bookingId} already exists');
    }
    _bookings[booking.bookingId] = booking;
    _publish();
  }

  @override
  Future<BookingModel?> getById(String bookingId) async => _bookings[bookingId];

  @override
  Future<void> save(BookingModel booking) async {
    _bookings[booking.bookingId] = booking;
    _publish();
  }

  @override
  Future<void> updateStatus(String bookingId, BookingStatus status) async {
    final booking = _bookings[bookingId];
    if (booking == null) throw StateError('Booking $bookingId was not found');
    await save(booking.copyWith(
      status: status,
      arrivalTime:
          status == BookingStatus.artisanArrived ? DateTime.now() : null,
      completionTime:
          status == BookingStatus.completed || status == BookingStatus.settled
              ? DateTime.now()
              : null,
    ));
  }

  List<BookingModel> _customerBookings(String customerId) => _bookings.values
      .where((booking) =>
          booking.customerId == customerId && booking.status.isActive)
      .toList(growable: false);

  List<BookingModel> _artisanBookings(String artisanId) => _bookings.values
      .where((booking) =>
          booking.assignedArtisanId == artisanId && booking.status.isActive)
      .toList(growable: false);

  @override
  Stream<List<BookingModel>> streamActiveBookings(String customerId) async* {
    yield _customerBookings(customerId);
    yield* _changes.stream.map((_) => _customerBookings(customerId));
  }

  @override
  Stream<List<BookingModel>> streamArtisanJobs(String artisanId) async* {
    yield _artisanBookings(artisanId);
    yield* _changes.stream.map((_) => _artisanBookings(artisanId));
  }

  Future<void> dispose() => _changes.close();
}

class InMemoryMandateRepository implements IMandateRepository {
  InMemoryMandateRepository([Iterable<MandateModel> seed = const []]) {
    for (final mandate in seed) {
      _mandates[mandate.mandateId] = mandate;
      _byIdempotencyKey[mandate.idempotencyKey] = mandate.mandateId;
    }
  }

  final Map<String, MandateModel> _mandates = {};
  final Map<String, String> _byIdempotencyKey = {};

  @override
  Future<MandateModel> createPreAuthMandate(MandateModel mandate) async {
    final duplicateId = _byIdempotencyKey[mandate.idempotencyKey];
    if (duplicateId != null) return _mandates[duplicateId]!;
    _mandates[mandate.mandateId] = mandate;
    _byIdempotencyKey[mandate.idempotencyKey] = mandate.mandateId;
    return mandate;
  }

  @override
  Future<MandateModel?> getById(String mandateId) async => _mandates[mandateId];

  @override
  Future<MandateModel> captureDoorstepFee(String mandateId) =>
      _setStatus(mandateId, UpiMandateStatus.captured);

  @override
  Future<MandateModel> releaseMandate(String mandateId) =>
      _setStatus(mandateId, UpiMandateStatus.released);

  Future<MandateModel> _setStatus(
    String mandateId,
    UpiMandateStatus status,
  ) async {
    final mandate = _mandates[mandateId];
    if (mandate == null) throw StateError('Mandate $mandateId was not found');
    final updated = mandate.copyWith(status: status, updatedAt: DateTime.now());
    _mandates[mandateId] = updated;
    return updated;
  }
}

class InMemoryWalletRepository implements IWalletRepository {
  InMemoryWalletRepository({
    Iterable<WalletModel> wallets = const [],
  }) {
    for (final wallet in wallets) {
      _wallets[wallet.artisanId] = wallet;
    }
  }

  final Map<String, WalletModel> _wallets = {};
  final Map<String, List<WalletSettlementEntry>> _ledger = {};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  void _publish() => _changes.add(null);

  @override
  Future<WalletModel?> getWalletByArtisanId(String artisanId) async =>
      _wallets[artisanId];

  @override
  Future<WalletSettlementEntry> recordSettlement(
    String artisanId,
    WalletSettlementEntry entry,
  ) async {
    final wallet = _wallets[artisanId] ??
        WalletModel(
          artisanId: artisanId,
          availableBalancePaise: 0,
          reserveBalancePaise: 200000,
          updatedAt: DateTime.now(),
        );
    final signedAmount =
        (entry.netPayout * 100).round() * (entry.isCredit ? 1 : -1);
    _wallets[artisanId] = wallet.copyWith(
      availableBalancePaise: wallet.availableBalancePaise + signedAmount,
      updatedAt: DateTime.now(),
    );
    _ledger.putIfAbsent(artisanId, () => []).insert(0, entry);
    _publish();
    return entry;
  }

  @override
  Future<WalletSettlementEntry> withdrawImps(
    String artisanId, {
    required int amountPaise,
    required String bankReference,
  }) async {
    final wallet = _wallets[artisanId];
    if (wallet == null) throw StateError('Wallet $artisanId was not found');
    if (amountPaise <= 0 || amountPaise > wallet.withdrawablePaise) {
      throw StateError('Withdrawal amount exceeds cleared wallet balance');
    }
    final entry = WalletSettlementEntry(
      id: 'imps_${DateTime.now().microsecondsSinceEpoch}',
      bookingId: 'PAYOUT_${DateTime.now().microsecondsSinceEpoch}',
      jobTitle: 'Instant IMPS Transfer',
      customerLocality: 'Guild Vault Payout',
      completedAtLabel: 'Just now',
      laborAmount: 0,
      partsPassThrough: 0,
      commissionRate: 0,
      commissionAmount: 0,
      netPayout: amountPaise / 100,
      isCredit: false,
      isImpsWithdrawal: true,
      statusLabel: 'IMPS Transferred',
      bankReference: bankReference,
      isToday: true,
    );
    return recordSettlement(artisanId, entry);
  }

  @override
  Future<List<WalletSettlementEntry>> getLedgerHistory(
          String artisanId) async =>
      List.unmodifiable(_ledger[artisanId] ?? const []);

  @override
  Stream<WalletModel?> streamWallet(String artisanId) async* {
    yield _wallets[artisanId];
    yield* _changes.stream.map((_) => _wallets[artisanId]);
  }

  @override
  Stream<List<WalletSettlementEntry>> streamLedgerHistory(
      String artisanId) async* {
    yield List.unmodifiable(_ledger[artisanId] ?? const []);
    yield* _changes.stream.map(
      (_) => List.unmodifiable(_ledger[artisanId] ?? const []),
    );
  }

  Future<void> dispose() => _changes.close();
}
