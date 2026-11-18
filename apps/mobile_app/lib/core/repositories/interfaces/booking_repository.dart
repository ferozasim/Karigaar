import '../../models/booking_model.dart';

abstract interface class IBookingRepository {
  Future<void> createBooking(BookingModel booking);
  Future<BookingModel?> getById(String bookingId);
  Future<void> updateStatus(String bookingId, BookingStatus status);
  Future<void> save(BookingModel booking);
  Stream<List<BookingModel>> streamActiveBookings(String customerId);
  Stream<List<BookingModel>> streamArtisanJobs(String artisanId);
}
