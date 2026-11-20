import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/artisan_profile_model.dart';
import '../../models/booking_model.dart';
import '../../models/booking_lifecycle.dart';
import '../../models/mandate_model.dart';
import '../../models/user_profile_model.dart';
import '../../models/user_role.dart';
import '../../models/support_case.dart';
import '../../models/wallet_model.dart';
import '../../models/wallet_settlement_entry.dart';
import '../interfaces/artisan_repository.dart';
import '../interfaces/booking_repository.dart';
import '../interfaces/mandate_repository.dart';
import '../interfaces/user_repository.dart';
import '../interfaces/support_case_repository.dart';
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
  List<BookingModel> get snapshot => List.unmodifiable(_bookings.values);
  final StreamController<void> _changes = StreamController<void>.broadcast();

  void _publish() => _changes.add(null);

  @override
  Future<void> createBooking(BookingModel booking) async {
    final existing = _bookings[booking.bookingId];
    if (existing != null) {
      if (existing.idempotencyKey == booking.idempotencyKey) return;
      throw StateError('Booking ${booking.bookingId} already exists');
    }
    _bookings[booking.bookingId] = booking;
    _publish();
  }

  @override
  Future<BookingModel?> getById(String bookingId) async => _bookings[bookingId];

  @override
  Stream<BookingModel?> streamBooking(String bookingId) async* {
    yield _bookings[bookingId];
    yield* _changes.stream.map((_) => _bookings[bookingId]);
  }

  @override
  Future<void> save(BookingModel booking) async {
    _bookings[booking.bookingId] = booking;
    _publish();
  }

  @override
  Future<void> updateStatus(String bookingId, BookingStatus status) async {
    final booking = _bookings[bookingId];
    if (booking == null) throw StateError('Booking $bookingId was not found');
    await transitionBooking(
      bookingId: bookingId,
      to: status,
      actorId: 'system',
      actorRole: UserRole.admin,
      eventKey: 'legacy_${booking.status.name}_${status.name}',
    );
  }

  @override
  Future<BookingModel> transitionBooking({
    required String bookingId,
    required BookingStatus to,
    required String actorId,
    required UserRole actorRole,
    required String eventKey,
    String? reason,
    String? assignArtisanId,
    String? assignArtisanName,
    String? assignArtisanPhone,
  }) async {
    final booking = _bookings[bookingId];
    if (booking == null) throw StateError('Booking $bookingId was not found');
    final priorEvent = booking.statusEvents
        .where((event) => event.eventKey == eventKey)
        .firstOrNull;
    if (priorEvent != null) return booking;
    if (!BookingLifecycle.canTransition(booking.status, to,
        actorRole: actorRole)) {
      throw StateError('Invalid booking transition ${booking.status.name} -> ${to.name}');
    }
    if (assignArtisanId != null &&
        !BookingLifecycle.canAssign(
          to: to,
          actorId: actorId,
          assignedArtisanId: assignArtisanId,
        )) {
      throw StateError('Only a claiming artisan can assign this booking');
    }
    final now = DateTime.now().toUtc();
    final event = BookingStatusEvent(
      from: booking.status,
      to: to,
      actorId: actorId,
      actorRole: actorRole,
      eventKey: eventKey,
      occurredAt: now,
      reason: reason,
    );
    final updated = booking.copyWith(
      status: to,
      statusEvents: [...booking.statusEvents, event],
      clearAssignedArtisan: to == BookingStatus.dispatchFailed,
      assignedArtisanId: assignArtisanId,
      assignedArtisanName: assignArtisanName,
      assignedArtisanPhone: assignArtisanPhone,
      arrivalTime: to == BookingStatus.artisanArrived ? now : null,
      completionTime: to == BookingStatus.completed || to == BookingStatus.settled
          ? now
          : null,
    );
    await save(updated);
    return updated;
  }

  List<BookingModel> _customerBookings(String customerId) => _bookings.values
      .where((booking) =>
          booking.customerId == customerId && booking.status.isActive)
      .toList(growable: false);

  List<BookingModel> _allCustomerBookings(String customerId) => _bookings.values
      .where((booking) => booking.customerId == customerId)
      .toList(growable: false)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
  Stream<List<BookingModel>> streamCustomerBookings(String customerId) async* {
    yield _allCustomerBookings(customerId);
    yield* _changes.stream.map((_) => _allCustomerBookings(customerId));
  }

  @override
  Stream<List<BookingModel>> streamArtisanJobs(String artisanId) async* {
    yield _artisanBookings(artisanId);
    yield* _changes.stream.map((_) => _artisanBookings(artisanId));
  }

  Future<void> dispose() => _changes.close();
}

/// Local booking adapter backed by SharedPreferences so a pilot booking can be
/// reopened after app restart. If the platform store is unavailable, it keeps
/// operating with the same deterministic in-memory behavior as the test adapter.
class PersistentLocalBookingRepository implements IBookingRepository {
  PersistentLocalBookingRepository({Iterable<BookingModel> seed = const []})
      : _seed = seed.toList(growable: false) {
    _ready = _initialize();
  }

  static const _storageKey = 'booking_repository_v1';
  final List<BookingModel> _seed;
  late final Future<void> _ready;
  late InMemoryBookingRepository _delegate;

  Future<void> _initialize() async {
    var initial = _seed;
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_storageKey);
      if (raw != null) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        initial = decoded
            .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
            .toList(growable: false);
      }
    } on Object {
      // Keep the offline app available when the preference plugin is absent.
    }
    _delegate = InMemoryBookingRepository(initial);
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        jsonEncode(_delegate.snapshot.map((booking) => booking.toJson()).toList()),
      );
    } on Object {
      // In-memory state remains available if local disk persistence fails.
    }
  }

  @override
  Future<void> createBooking(BookingModel booking) async {
    await _ready;
    await _delegate.createBooking(booking);
    await _persist();
  }

  @override
  Future<BookingModel?> getById(String bookingId) async {
    await _ready;
    return _delegate.getById(bookingId);
  }

  @override
  Stream<BookingModel?> streamBooking(String bookingId) async* {
    await _ready;
    yield* _delegate.streamBooking(bookingId);
  }

  @override
  Future<void> save(BookingModel booking) async {
    await _ready;
    await _delegate.save(booking);
    await _persist();
  }

  @override
  Future<void> updateStatus(String bookingId, BookingStatus status) async {
    await _ready;
    await _delegate.updateStatus(bookingId, status);
    await _persist();
  }

  @override
  Future<BookingModel> transitionBooking({
    required String bookingId,
    required BookingStatus to,
    required String actorId,
    required UserRole actorRole,
    required String eventKey,
    String? reason,
    String? assignArtisanId,
    String? assignArtisanName,
    String? assignArtisanPhone,
  }) async {
    await _ready;
    final booking = await _delegate.transitionBooking(
      bookingId: bookingId,
      to: to,
      actorId: actorId,
      actorRole: actorRole,
      eventKey: eventKey,
      reason: reason,
      assignArtisanId: assignArtisanId,
      assignArtisanName: assignArtisanName,
      assignArtisanPhone: assignArtisanPhone,
    );
    await _persist();
    return booking;
  }

  @override
  Stream<List<BookingModel>> streamActiveBookings(String customerId) async* {
    await _ready;
    yield* _delegate.streamActiveBookings(customerId);
  }

  @override
  Stream<List<BookingModel>> streamCustomerBookings(String customerId) async* {
    await _ready;
    yield* _delegate.streamCustomerBookings(customerId);
  }

  @override
  Stream<List<BookingModel>> streamArtisanJobs(String artisanId) async* {
    await _ready;
    yield* _delegate.streamArtisanJobs(artisanId);
  }

  Future<void> dispose() async {
    await _ready;
    await _delegate.dispose();
  }
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

class InMemorySupportCaseRepository implements ISupportCaseRepository {
  InMemorySupportCaseRepository([Iterable<SupportCase> seed = const []]) {
    for (final supportCase in seed) {
      _cases[supportCase.caseId] = supportCase;
    }
  }

  final Map<String, SupportCase> _cases = {};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  @override
  Future<SupportCase> create(SupportCase supportCase) async {
    final duplicate = _cases.values
        .where((item) => item.idempotencyKey == supportCase.idempotencyKey)
        .firstOrNull;
    if (duplicate != null) return duplicate;
    _cases[supportCase.caseId] = supportCase;
    _changes.add(null);
    return supportCase;
  }

  @override
  Future<SupportCase?> getById(String caseId) async => _cases[caseId];

  List<SupportCase> _forBooking(String bookingId) => _cases.values
      .where((item) => item.bookingId == bookingId)
      .toList(growable: false)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Stream<List<SupportCase>> streamForBooking(String bookingId) async* {
    yield _forBooking(bookingId);
    yield* _changes.stream.map((_) => _forBooking(bookingId));
  }

  Future<void> dispose() => _changes.close();
}

class PersistentLocalSupportCaseRepository implements ISupportCaseRepository {
  PersistentLocalSupportCaseRepository() {
    _ready = _initialize();
  }

  static const _storageKey = 'support_cases_v1';
  late final Future<void> _ready;
  late InMemorySupportCaseRepository _delegate;

  Future<void> _initialize() async {
    var initial = <SupportCase>[];
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_storageKey);
      if (raw != null) {
        initial = (jsonDecode(raw) as List)
            .map((item) => SupportCase.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ))
            .toList(growable: false);
      }
    } catch (_) {
      // Keep the local support flow available when platform storage is absent.
    }
    for (final supportCase in initial) {
      _saved[supportCase.caseId] = supportCase;
    }
    _delegate = InMemorySupportCaseRepository(initial);
  }

  Future<void> _persist() async {
    try {
      final all = <SupportCase>[];
      // The delegate owns the in-memory snapshot and exposes scoped streams;
      // persisted submissions are mirrored in this instance's local cache.
      all.addAll(_saved.values);
      await (await SharedPreferences.getInstance()).setString(
        _storageKey,
        jsonEncode(all.map((item) => item.toJson()).toList()),
      );
    } catch (_) {
      // In-memory mode remains usable if persistence is temporarily unavailable.
    }
  }

  final Map<String, SupportCase> _saved = {};

  @override
  Future<SupportCase> create(SupportCase supportCase) async {
    await _ready;
    final savedDuplicate = _saved.values
        .where((item) => item.idempotencyKey == supportCase.idempotencyKey)
        .firstOrNull;
    if (savedDuplicate != null) return savedDuplicate;
    final result = await _delegate.create(supportCase);
    _saved[result.caseId] = result;
    await _persist();
    return result;
  }

  @override
  Future<SupportCase?> getById(String caseId) async {
    await _ready;
    return _saved[caseId] ?? _delegate.getById(caseId);
  }

  @override
  Stream<List<SupportCase>> streamForBooking(String bookingId) async* {
    await _ready;
    yield* _delegate.streamForBooking(bookingId);
  }

  Future<void> dispose() async {
    await _ready;
    await _delegate.dispose();
  }
}
