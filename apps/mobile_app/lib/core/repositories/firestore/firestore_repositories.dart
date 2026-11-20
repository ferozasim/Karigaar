import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/artisan_profile_model.dart';
import '../../models/booking_model.dart';
import '../../models/booking_lifecycle.dart';
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
import 'firestore_serializers.dart';

Map<String, dynamic> _dataWithId(DocumentSnapshot<Map<String, dynamic>> doc) =>
    {
      ...?doc.data(),
      if (!(doc.data() ?? const {}).containsKey('userId')) 'userId': doc.id,
      if (!(doc.data() ?? const {}).containsKey('artisanId'))
        'artisanId': doc.id,
      if (!(doc.data() ?? const {}).containsKey('bookingId'))
        'bookingId': doc.id,
      if (!(doc.data() ?? const {}).containsKey('mandateId'))
        'mandateId': doc.id,
      if (!(doc.data() ?? const {}).containsKey('id')) 'id': doc.id,
    };

class FirestoreUserRepository implements IUserRepository {
  FirestoreUserRepository(this._firestore);
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<UserProfileModel?> getById(String userId) async {
    final doc = await _users.doc(userId).get();
    return doc.exists ? UserProfileModel.fromJson(_dataWithId(doc)) : null;
  }

  @override
  Future<void> save(UserProfileModel user) =>
      _users.doc(user.userId).set(user.toJson(), SetOptions(merge: true));

  @override
  Stream<UserProfileModel?> streamUser(String userId) =>
      _users.doc(userId).snapshots().map((doc) =>
          doc.exists ? UserProfileModel.fromJson(_dataWithId(doc)) : null);

  @override
  Future<void> updateRole(String userId, UserRole role) =>
      _users.doc(userId).update({
        'activeRole': role.name,
        'updatedAt': DateTime.now().toIso8601String(),
      });
}

class FirestoreArtisanRepository implements IArtisanRepository {
  FirestoreArtisanRepository(this._firestore);
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _artisans =>
      _firestore.collection('artisans');

  @override
  Future<ArtisanProfileModel?> getById(String artisanId) async {
    final doc = await _artisans.doc(artisanId).get();
    return doc.exists
        ? FirestoreSerializers.artisanFromJson(_dataWithId(doc))
        : null;
  }

  @override
  Future<List<ArtisanProfileModel>> getByDistrict(String cityId) async {
    final result = await _artisans.where('cityId', isEqualTo: cityId).get();
    return result.docs
        .map((doc) => FirestoreSerializers.artisanFromJson(_dataWithId(doc)))
        .toList(growable: false);
  }

  @override
  Future<void> save(ArtisanProfileModel artisan) =>
      _artisans.doc(artisan.artisanId).set(
          FirestoreSerializers.artisanToJson(artisan), SetOptions(merge: true));

  @override
  Future<void> updateProfile(ArtisanProfileModel artisan) => save(artisan);

  @override
  Future<void> updateRateCard(
    String artisanId, {
    required int inspectionFee,
    required int dailyDihadiRate,
  }) =>
      _artisans.doc(artisanId).update({
        'inspectionFee': inspectionFee,
        'dailyDihadiRate': dailyDihadiRate,
      });

  @override
  Stream<List<ArtisanProfileModel>> streamArtisans(String cityId) => _artisans
      .where('cityId', isEqualTo: cityId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FirestoreSerializers.artisanFromJson(_dataWithId(doc)))
          .toList(growable: false));
}

class FirestoreBookingRepository implements IBookingRepository {
  FirestoreBookingRepository(this._firestore);
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _bookings =>
      _firestore.collection('bookings');

  @override
  Future<void> createBooking(BookingModel booking) async {
    final reference = _bookings.doc(booking.bookingId);
    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(reference);
      if (existing.exists) {
        final prior = BookingModel.fromJson(_dataWithId(existing));
        if (prior.idempotencyKey == booking.idempotencyKey) return;
        throw StateError('Booking ${booking.bookingId} already exists');
      }
      transaction.set(reference, booking.toJson());
    });
  }

  @override
  Future<BookingModel?> getById(String bookingId) async {
    final doc = await _bookings.doc(bookingId).get();
    return doc.exists ? BookingModel.fromJson(_dataWithId(doc)) : null;
  }

  @override
  Stream<BookingModel?> streamBooking(String bookingId) =>
      _bookings.doc(bookingId).snapshots().map((doc) =>
          doc.exists ? BookingModel.fromJson(_dataWithId(doc)) : null);

  @override
  Future<void> save(BookingModel booking) => _bookings
      .doc(booking.bookingId)
      .set(booking.toJson(), SetOptions(merge: true));

  @override
  Future<void> updateStatus(String bookingId, BookingStatus status) =>
      transitionBooking(
        bookingId: bookingId,
        to: status,
        actorId: 'system',
        actorRole: UserRole.admin,
        eventKey: 'legacy_${DateTime.now().microsecondsSinceEpoch}',
      ).then((_) {});

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
      _firestore.runTransaction((transaction) async {
        final reference = _bookings.doc(bookingId);
        final snapshot = await transaction.get(reference);
        if (!snapshot.exists) throw StateError('Booking $bookingId was not found');
        final booking = BookingModel.fromJson(_dataWithId(snapshot));
        final previousEvent = booking.statusEvents
            .where((event) => event.eventKey == eventKey)
            .firstOrNull;
        if (previousEvent != null) return booking;
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
        final updated = booking.copyWith(
          status: to,
          assignedArtisanId: assignArtisanId,
          assignedArtisanName: assignArtisanName,
          assignedArtisanPhone: assignArtisanPhone,
          statusEvents: [
            ...booking.statusEvents,
            BookingStatusEvent(
              from: booking.status,
              to: to,
              actorId: actorId,
              actorRole: actorRole,
              eventKey: eventKey,
              occurredAt: now,
              reason: reason,
            ),
          ],
          clearAssignedArtisan: to == BookingStatus.dispatchFailed,
          arrivalTime: to == BookingStatus.artisanArrived ? now : null,
          completionTime:
              to == BookingStatus.completed || to == BookingStatus.settled
                  ? now
                  : null,
        );
        transaction.set(reference, updated.toJson());
        return updated;
      });

  @override
  Stream<List<BookingModel>> streamActiveBookings(String customerId) =>
      _bookings.where('customerId', isEqualTo: customerId).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromJson(_dataWithId(doc)))
              .where((booking) => booking.status.isActive)
              .toList(growable: false));

  @override
  Stream<List<BookingModel>> streamArtisanJobs(String artisanId) => _bookings
      .where('assignedArtisanId', isEqualTo: artisanId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => BookingModel.fromJson(_dataWithId(doc)))
          .where((booking) => booking.status.isActive)
          .toList(growable: false));
}

class FirestoreMandateRepository implements IMandateRepository {
  FirestoreMandateRepository(this._firestore);
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _mandates =>
      _firestore.collection('mandates');

  @override
  Future<MandateModel> createPreAuthMandate(MandateModel mandate) async {
    final existing = await _mandates
        .where('idempotencyKey', isEqualTo: mandate.idempotencyKey)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      return MandateModel.fromJson(_dataWithId(existing.docs.first));
    }
    await _mandates.doc(mandate.mandateId).set(mandate.toJson());
    return mandate;
  }

  @override
  Future<MandateModel?> getById(String mandateId) async {
    final doc = await _mandates.doc(mandateId).get();
    return doc.exists ? MandateModel.fromJson(_dataWithId(doc)) : null;
  }

  @override
  Future<MandateModel> captureDoorstepFee(String mandateId) =>
      _updateStatus(mandateId, UpiMandateStatus.captured);

  @override
  Future<MandateModel> releaseMandate(String mandateId) =>
      _updateStatus(mandateId, UpiMandateStatus.released);

  Future<MandateModel> _updateStatus(
    String mandateId,
    UpiMandateStatus status,
  ) async {
    await _mandates.doc(mandateId).update({
      'status': status.name,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    final mandate = await getById(mandateId);
    if (mandate == null) throw StateError('Mandate $mandateId was not found');
    return mandate;
  }
}

class FirestoreWalletRepository implements IWalletRepository {
  FirestoreWalletRepository(this._firestore);
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _wallets =>
      _firestore.collection('wallets');

  CollectionReference<Map<String, dynamic>> _ledger(String artisanId) =>
      _wallets.doc(artisanId).collection('ledger');

  @override
  Future<WalletModel?> getWalletByArtisanId(String artisanId) async {
    final doc = await _wallets.doc(artisanId).get();
    if (!doc.exists) return null;
    return WalletModel.fromJson({..._dataWithId(doc), 'artisanId': artisanId});
  }

  @override
  Future<WalletSettlementEntry> recordSettlement(
    String artisanId,
    WalletSettlementEntry entry,
  ) async {
    await _ledger(artisanId).doc(entry.id).set(entry.toJson());
    return entry;
  }

  @override
  Future<WalletSettlementEntry> withdrawImps(
    String artisanId, {
    required int amountPaise,
    required String bankReference,
  }) {
    throw UnsupportedError(
      'Live IMPS withdrawals must be authorized by the T-12 server webhook.',
    );
  }

  @override
  Future<List<WalletSettlementEntry>> getLedgerHistory(String artisanId) async {
    final snapshot = await _ledger(artisanId).get();
    return snapshot.docs
        .map((doc) => WalletSettlementEntry.fromJson(_dataWithId(doc)))
        .toList(growable: false);
  }

  @override
  Stream<WalletModel?> streamWallet(String artisanId) =>
      _wallets.doc(artisanId).snapshots().map((doc) => doc.exists
          ? WalletModel.fromJson({..._dataWithId(doc), 'artisanId': artisanId})
          : null);

  @override
  Stream<List<WalletSettlementEntry>> streamLedgerHistory(String artisanId) =>
      _ledger(artisanId).snapshots().map((snapshot) => snapshot.docs
          .map((doc) => WalletSettlementEntry.fromJson(_dataWithId(doc)))
          .toList(growable: false));
}
