import '../../models/artisan_profile_model.dart';

abstract interface class IArtisanRepository {
  Future<ArtisanProfileModel?> getById(String artisanId);
  Future<List<ArtisanProfileModel>> getByDistrict(String cityId);
  Future<void> save(ArtisanProfileModel artisan);
  Future<void> updateProfile(ArtisanProfileModel artisan);
  Future<void> updateRateCard(
    String artisanId, {
    required int inspectionFee,
    required int dailyDihadiRate,
  });
  Stream<List<ArtisanProfileModel>> streamArtisans(String cityId);
}
