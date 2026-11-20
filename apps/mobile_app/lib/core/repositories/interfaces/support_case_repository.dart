import '../../models/support_case.dart';

abstract interface class ISupportCaseRepository {
  Future<SupportCase> create(SupportCase supportCase);
  Future<SupportCase?> getById(String caseId);
  Stream<List<SupportCase>> streamForBooking(String bookingId);
}
