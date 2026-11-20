import '../../models/booking_model.dart';
import '../../models/user_role.dart';

abstract interface class IBookingRepository {
  Future<void> createBooking(BookingModel booking);
  Future<BookingModel?> getById(String bookingId);
  Stream<BookingModel?> streamBooking(String bookingId);
  Future<void> updateStatus(String bookingId, BookingStatus status);
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
  });
  Future<void> save(BookingModel booking);
  Stream<List<BookingModel>> streamActiveBookings(String customerId);
  Stream<List<BookingModel>> streamArtisanJobs(String artisanId);
}
