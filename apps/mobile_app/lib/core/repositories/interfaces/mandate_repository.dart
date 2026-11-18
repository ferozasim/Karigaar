import '../../models/mandate_model.dart';

abstract interface class IMandateRepository {
  Future<MandateModel> createPreAuthMandate(MandateModel mandate);
  Future<MandateModel?> getById(String mandateId);
  Future<MandateModel> captureDoorstepFee(String mandateId);
  Future<MandateModel> releaseMandate(String mandateId);
}
