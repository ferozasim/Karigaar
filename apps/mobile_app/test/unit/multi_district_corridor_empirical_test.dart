import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/config/app_data_service.dart';
import 'package:karigaar_app/core/models/artisan_profile_model.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Empirical Verification: Ticket T-01 Multi-District Corridor & Artisan Discovery', () {
    const expectedDistricts = [
      {'cityId': 'city_nanded_01', 'name': 'Nanded', 'minArtisans': 4, 'minLocalities': 10},
      {'cityId': 'dist_parbhani', 'name': 'Parbhani', 'minArtisans': 4, 'minLocalities': 4},
      {'cityId': 'dist_latur', 'name': 'Latur', 'minArtisans': 4, 'minLocalities': 4},
      {'cityId': 'dist_hingoli', 'name': 'Hingoli', 'minArtisans': 3, 'minLocalities': 3},
      {'cityId': 'dist_aurangabad', 'name': 'Chhatrapati Sambhajinagar', 'minArtisans': 4, 'minLocalities': 4},
      {'cityId': 'dist_nagpur', 'name': 'Nagpur', 'minArtisans': 4, 'minLocalities': 4},
      {'cityId': 'dist_nizamabad', 'name': 'Nizamabad', 'minArtisans': 4, 'minLocalities': 4},
    ];

    test('All 7 regional corridor districts exist and match expected metadata', () async {
      final districts = await AppDataService.loadRegionalDistricts();
      expect(districts.length, equals(7), reason: 'Expected exactly 7 regional corridor districts');

      for (final expected in expectedDistricts) {
        final match = districts.where((d) => d.cityId == expected['cityId']).toList();
        expect(match, isNotEmpty, reason: 'District ${expected['cityId']} must exist in corridor');
        final district = match.first;
        expect(district.name, equals(expected['name']));
        expect(district.localities.length, greaterThanOrEqualTo(expected['minLocalities'] as int));
      }
    });

    test('All corridor locality IDs across all 7 districts are globally unique', () async {
      final districts = await AppDataService.loadRegionalDistricts();
      final localityIds = <String>{};
      int totalLocalities = 0;

      for (final district in districts) {
        for (final loc in district.localities) {
          totalLocalities++;
          expect(localityIds.contains(loc.localityId), isFalse,
              reason: 'Duplicate locality ID found: ${loc.localityId} in ${district.name}');
          localityIds.add(loc.localityId);
        }
      }
      expect(totalLocalities, equals(33), reason: 'Expected total 33 localities across 7 districts');
    });

    test('Each of the 7 districts yields authentic, active artisans with valid local locality IDs', () async {
      final districts = await AppDataService.loadRegionalDistricts();

      for (final expected in expectedDistricts) {
        final cityId = expected['cityId'] as String;
        final district = districts.firstWhere((d) => d.cityId == cityId);
        final validLocalityIds = district.localities.map((l) => l.localityId).toSet();

        final artisans = AppDataService.getArtisansForDistrict(cityId);
        expect(artisans, isNotEmpty, reason: 'District $cityId must have artisans');
        expect(artisans.length, greaterThanOrEqualTo(expected['minArtisans'] as int));

        for (final artisan in artisans) {
          // Verify cityId matches district
          expect(artisan.cityId, equals(cityId),
              reason: 'Artisan ${artisan.name} cityId must match $cityId');

          // Verify localityId exists in that district's localities
          expect(validLocalityIds.contains(artisan.localityId), isTrue,
              reason: 'Artisan ${artisan.name} localityId (${artisan.localityId}) must exist in district ${district.name} localities');

          // Verify authentic fields
          expect(artisan.artisanId, isNotEmpty);
          expect(artisan.name, isNotEmpty);
          expect(artisan.phone, startsWith('+91'));
          expect(artisan.phone.length, equals(13)); // +91 followed by 10 digits
          expect(artisan.primaryTradeId, startsWith('trade_'));
          expect(artisan.rating, greaterThanOrEqualTo(4.8));
          expect(artisan.reviewCount, greaterThan(0));
          expect(artisan.totalJobsCompleted, greaterThan(0));
          expect(artisan.inspectionFee, greaterThan(0));
          expect(artisan.bio, isNotEmpty);
          expect(artisan.tier, anyOf(GuildTier.masterGuildsman, GuildTier.guildVerifiedPro));
        }
      }
    });

    test('getAllSampleArtisans returns complete corridor roster with globally unique artisan IDs', () {
      final allArtisans = AppDataService.getAllSampleArtisans();
      expect(allArtisans.length, equals(27), reason: '4+4+4+3+4+4+4 = 27 artisans across corridor');

      final artisanIds = <String>{};
      for (final artisan in allArtisans) {
        expect(artisanIds.contains(artisan.artisanId), isFalse,
            reason: 'Duplicate artisan ID found: ${artisan.artisanId}');
        artisanIds.add(artisan.artisanId);
      }
    });

    test('artisanByIdProvider correctly resolves every artisan ID across all 7 corridor districts', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final allArtisans = AppDataService.getAllSampleArtisans();

      for (final expectedArtisan in allArtisans) {
        final resolvedArtisan = container.read(artisanByIdProvider(expectedArtisan.artisanId));
        expect(resolvedArtisan.artisanId, equals(expectedArtisan.artisanId));
        expect(resolvedArtisan.name, equals(expectedArtisan.name));
        expect(resolvedArtisan.cityId, equals(expectedArtisan.cityId));
        expect(resolvedArtisan.localityId, equals(expectedArtisan.localityId));
      }
    });

    test('artisanByIdProvider safely falls back for non-existent artisan ID without crashing', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final fallback = container.read(artisanByIdProvider('non_existent_artisan_99999'));
      expect(fallback, isNotNull);
      expect(fallback.artisanId, equals('art_nanded_01'));
    });

    test('topArtisansProvider reactively updates across all 7 districts when switching district', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final districts = await AppDataService.loadRegionalDistricts();

      // Verify default is Nanded
      final initialArtisans = container.read(topArtisansProvider);
      expect(initialArtisans.first.cityId, equals('city_nanded_01'));
      expect(initialArtisans.first.name, equals('Ganesh Kadam'));

      // Cycle through each of the 7 districts
      for (final district in districts) {
        container.read(selectedDistrictProvider.notifier).state = district;

        final currentArtisans = container.read(topArtisansProvider);
        expect(currentArtisans, isNotEmpty);
        expect(currentArtisans.every((a) => a.cityId == district.cityId), isTrue,
            reason: 'All artisans in topArtisansProvider must belong to ${district.name} (${district.cityId})');

        final expectedRoster = AppDataService.getArtisansForDistrict(district.cityId);
        expect(currentArtisans.length, equals(expectedRoster.length));
        expect(currentArtisans.first.artisanId, equals(expectedRoster.first.artisanId));
      }
    });

    test('Unknown district cityId gracefully falls back to Nanded artisans', () {
      final fallbackArtisans = AppDataService.getArtisansForDistrict('unknown_district_xyz');
      expect(fallbackArtisans, isNotEmpty);
      expect(fallbackArtisans.first.cityId, equals('city_nanded_01'));
      expect(fallbackArtisans.first.name, equals('Ganesh Kadam'));
    });
  });
}
