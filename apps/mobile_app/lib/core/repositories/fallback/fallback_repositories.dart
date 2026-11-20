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

/// Uses the local repository when a Firebase operation cannot complete.
///
/// [UnsupportedError] is deliberately not hidden: it represents a business
/// capability that needs an authorised backend (for example, live IMPS payout),
/// rather than a connectivity failure.
Future<T> _withFallback<T>(
  Future<T> Function() primary,
  Future<T> Function() fallback,
) async {
  try {
    return await primary();
  } on UnsupportedError {
    rethrow;
  } catch (_) {
    return fallback();
  }
}

Stream<T> _streamWithFallback<T>(Stream<T> primary, Stream<T> fallback) async* {
  try {
    yield* primary;
  } catch (_) {
    yield* fallback;
  }
}

class FallbackUserRepository implements IUserRepository {
  FallbackUserRepository(this._primary, this._fallback);
  final IUserRepository _primary;
  final IUserRepository _fallback;

  @override
  Future<UserProfileModel?> getById(String userId) => _withFallback(
      () => _primary.getById(userId), () => _fallback.getById(userId));

  @override
  Future<void> save(UserProfileModel user) =>
      _withFallback(() => _primary.save(user), () => _fallback.save(user));

  @override
  Stream<UserProfileModel?> streamUser(String userId) => _streamWithFallback(
        _primary.streamUser(userId),
        _fallback.streamUser(userId),
      );

  @override
  Future<void> updateRole(String userId, UserRole role) => _withFallback(
        () => _primary.updateRole(userId, role),
        () => _fallback.updateRole(userId, role),
      );
}

class FallbackArtisanRepository implements IArtisanRepository {
  FallbackArtisanRepository(this._primary, this._fallback);
  final IArtisanRepository _primary;
  final IArtisanRepository _fallback;

  @override
  Future<ArtisanProfileModel?> getById(String artisanId) => _withFallback(
        () => _primary.getById(artisanId),
        () => _fallback.getById(artisanId),
      );

  @override
  Future<List<ArtisanProfileModel>> getByDistrict(String cityId) =>
      _withFallback(
        () => _primary.getByDistrict(cityId),
        () => _fallback.getByDistrict(cityId),
      );

  @override
  Future<void> save(ArtisanProfileModel artisan) => _withFallback(
      () => _primary.save(artisan), () => _fallback.save(artisan));

  @override
  Stream<List<ArtisanProfileModel>> streamArtisans(String cityId) =>
      _streamWithFallback(
        _primary.streamArtisans(cityId),
        _fallback.streamArtisans(cityId),
      );

  @override
  Future<void> updateProfile(ArtisanProfileModel artisan) => _withFallback(
        () => _primary.updateProfile(artisan),
        () => _fallback.updateProfile(artisan),
      );

  @override
  Future<void> updateRateCard(
    String artisanId, {
    required int inspectionFee,
    required int dailyDihadiRate,
  }) =>
      _withFallback(
        () => _primary.updateRateCard(
          artisanId,
          inspectionFee: inspectionFee,
          dailyDihadiRate: dailyDihadiRate,
        ),
        () => _fallback.updateRateCard(
          artisanId,
          inspectionFee: inspectionFee,
          dailyDihadiRate: dailyDihadiRate,
        ),
      );
}

class FallbackBookingRepository implements IBookingRepository {
  FallbackBookingRepository(this._primary, this._fallback);
  final IBookingRepository _primary;
  final IBookingRepository _fallback;

  @override
  Future<void> createBooking(BookingModel booking) => _withFallback(
        () => _primary.createBooking(booking),
        () => _fallback.createBooking(booking),
      );

  @override
  Future<BookingModel?> getById(String bookingId) => _withFallback(
        () => _primary.getById(bookingId),
        () => _fallback.getById(bookingId),
      );

  @override
  Stream<BookingModel?> streamBooking(String bookingId) => _streamWithFallback(
        _primary.streamBooking(bookingId),
        _fallback.streamBooking(bookingId),
      );

  @override
  Future<void> save(BookingModel booking) => _withFallback(
      () => _primary.save(booking), () => _fallback.save(booking));

  @override
  Stream<List<BookingModel>> streamActiveBookings(String customerId) =>
      _streamWithFallback(
        _primary.streamActiveBookings(customerId),
        _fallback.streamActiveBookings(customerId),
      );

  @override
  Stream<List<BookingModel>> streamArtisanJobs(String artisanId) =>
      _streamWithFallback(
        _primary.streamArtisanJobs(artisanId),
        _fallback.streamArtisanJobs(artisanId),
      );

  @override
  Future<void> updateStatus(String bookingId, BookingStatus status) =>
      _withFallback(
        () => _primary.updateStatus(bookingId, status),
        () => _fallback.updateStatus(bookingId, status),
      );

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
  }) =>
      _withFallback(
        () => _primary.transitionBooking(
          bookingId: bookingId,
          to: to,
          actorId: actorId,
          actorRole: actorRole,
          eventKey: eventKey,
          reason: reason,
          assignArtisanId: assignArtisanId,
          assignArtisanName: assignArtisanName,
          assignArtisanPhone: assignArtisanPhone,
        ),
        () => _fallback.transitionBooking(
          bookingId: bookingId,
          to: to,
          actorId: actorId,
          actorRole: actorRole,
          eventKey: eventKey,
          reason: reason,
          assignArtisanId: assignArtisanId,
          assignArtisanName: assignArtisanName,
          assignArtisanPhone: assignArtisanPhone,
        ),
      );
}

class FallbackMandateRepository implements IMandateRepository {
  FallbackMandateRepository(this._primary, this._fallback);
  final IMandateRepository _primary;
  final IMandateRepository _fallback;

  @override
  Future<MandateModel> captureDoorstepFee(String mandateId) => _withFallback(
        () => _primary.captureDoorstepFee(mandateId),
        () => _fallback.captureDoorstepFee(mandateId),
      );

  @override
  Future<MandateModel> createPreAuthMandate(MandateModel mandate) =>
      _withFallback(
        () => _primary.createPreAuthMandate(mandate),
        () => _fallback.createPreAuthMandate(mandate),
      );

  @override
  Future<MandateModel?> getById(String mandateId) => _withFallback(
        () => _primary.getById(mandateId),
        () => _fallback.getById(mandateId),
      );

  @override
  Future<MandateModel> releaseMandate(String mandateId) => _withFallback(
        () => _primary.releaseMandate(mandateId),
        () => _fallback.releaseMandate(mandateId),
      );
}

class FallbackWalletRepository implements IWalletRepository {
  FallbackWalletRepository(this._primary, this._fallback);
  final IWalletRepository _primary;
  final IWalletRepository _fallback;

  @override
  Future<List<WalletSettlementEntry>> getLedgerHistory(String artisanId) =>
      _withFallback(
        () => _primary.getLedgerHistory(artisanId),
        () => _fallback.getLedgerHistory(artisanId),
      );

  @override
  Future<WalletModel?> getWalletByArtisanId(String artisanId) => _withFallback(
        () => _primary.getWalletByArtisanId(artisanId),
        () => _fallback.getWalletByArtisanId(artisanId),
      );

  @override
  Future<WalletSettlementEntry> recordSettlement(
    String artisanId,
    WalletSettlementEntry entry,
  ) =>
      _withFallback(
        () => _primary.recordSettlement(artisanId, entry),
        () => _fallback.recordSettlement(artisanId, entry),
      );

  @override
  Stream<List<WalletSettlementEntry>> streamLedgerHistory(String artisanId) =>
      _streamWithFallback(
        _primary.streamLedgerHistory(artisanId),
        _fallback.streamLedgerHistory(artisanId),
      );

  @override
  Stream<WalletModel?> streamWallet(String artisanId) => _streamWithFallback(
        _primary.streamWallet(artisanId),
        _fallback.streamWallet(artisanId),
      );

  @override
  Future<WalletSettlementEntry> withdrawImps(
    String artisanId, {
    required int amountPaise,
    required String bankReference,
  }) =>
      _withFallback(
        () => _primary.withdrawImps(
          artisanId,
          amountPaise: amountPaise,
          bankReference: bankReference,
        ),
        () => _fallback.withdrawImps(
          artisanId,
          amountPaise: amountPaise,
          bankReference: bankReference,
        ),
      );
}
