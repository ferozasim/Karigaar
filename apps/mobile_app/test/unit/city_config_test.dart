import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/city_model.dart';
import 'package:karigaar_app/core/config/app_data_service.dart';

void main() {
  group('Pilot City (Nanded, Maharashtra) Config Tests', () {
    test('Nanded default configuration is properly initialized', () {
      final sampleArtisans = AppDataService.getSampleNandedArtisans();
      expect(sampleArtisans, isNotEmpty);
      expect(sampleArtisans.first.cityId, equals('city_nanded_01'));
      expect(sampleArtisans.first.localityId, equals('loc_anand_nagar'));
    });

    test('LocalityModel parses JSON accurately', () {
      final json = {
        'localityId': 'loc_anand_nagar',
        'name': 'Anand Nagar',
        'marathiName': 'आनंद नगर',
        'pincode': '431602',
        'center': {'latitude': 19.1685, 'longitude': 77.3090},
        'radiusKm': 2.0,
        'density': 'HIGH_RESIDENTIAL',
        'emergencyHub': true,
      };

      final locality = LocalityModel.fromJson(json);
      expect(locality.localityId, equals('loc_anand_nagar'));
      expect(locality.name, equals('Anand Nagar'));
      expect(locality.marathiName, equals('आनंद नगर'));
      expect(locality.pincode, equals('431602'));
      expect(locality.center.latitude, equals(19.1685));
      expect(locality.center.longitude, equals(77.3090));
      expect(locality.radiusKm, equals(2.0));
      expect(locality.emergencyHub, isTrue);
    });

    test('CityConfigModel validates Nanded boundary and pincodes', () {
      final json = {
        'cityId': 'city_nanded_01',
        'name': 'Nanded',
        'fullName': 'Nanded-Waghala, Maharashtra',
        'state': 'Maharashtra',
        'country': 'India',
        'pincodeRange': ['431601', '431602', '431603', '431604', '431605', '431606'],
        'centerCoordinates': {'latitude': 19.1383, 'longitude': 77.3210},
        'defaultDispatchRadiusKm': 4.5,
        'emergencyDispatchWindowMins': 25,
        'currencySymbol': '₹',
        'localities': [
          {
            'localityId': 'loc_vazirabad',
            'name': 'Vazirabad & Sarafa',
            'marathiName': 'वजिराबाद आणि सराफा',
            'pincode': '431601',
            'center': {'latitude': 19.1555, 'longitude': 77.3190},
            'radiusKm': 2.5,
            'density': 'HIGH_COMMERCIAL_RESIDENTIAL',
            'emergencyHub': true,
          },
          {
            'localityId': 'loc_vishnupuri',
            'name': 'Vishnupuri & SRTMUN Campus',
            'marathiName': 'विष्णुपुरी',
            'pincode': '431606',
            'center': {'latitude': 19.1020, 'longitude': 77.2920},
            'radiusKm': 4.0,
            'density': 'INSTITUTIONAL_RESIDENTIAL',
            'emergencyHub': false,
          }
        ]
      };

      final city = CityConfigModel.fromJson(json);
      expect(city.cityId, equals('city_nanded_01'));
      expect(city.state, equals('Maharashtra'));
      expect(city.pincodeRange, contains('431601'));
      expect(city.pincodeRange, contains('431605'));
      expect(city.pincodeRange, contains('431606'));
      expect(city.emergencyDispatchWindowMins, equals(25));
      expect(city.defaultDispatchRadiusKm, equals(4.5));
      expect(city.localities.length, equals(2));
      for (final loc in city.localities) {
        expect(city.pincodeRange, contains(loc.pincode),
            reason: 'Locality ${loc.name} pincode ${loc.pincode} must be in city pincodeRange');
      }
    });
  });
}
