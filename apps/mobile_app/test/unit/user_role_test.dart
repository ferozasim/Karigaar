import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/user_role.dart';

void main() {
  group('Unified User Role Switcher Tests', () {
    test('UserRole switches seamlessly between Customer and Artisan', () {
      const customerRole = UserRole.customer;
      expect(customerRole.isCustomer, isTrue);
      expect(customerRole.isArtisan, isFalse);
      expect(customerRole.toggleMode, equals(UserRole.artisan));

      const artisanRole = UserRole.artisan;
      expect(artisanRole.isArtisan, isTrue);
      expect(artisanRole.isCustomer, isFalse);
      expect(artisanRole.toggleMode, equals(UserRole.customer));
    });

    test('UserRole display names and taglines are well formed', () {
      expect(UserRole.customer.displayName, equals('Homeowner'));
      expect(UserRole.artisan.displayName, equals('Karigaar Partner'));
      expect(UserRole.customer.localizedTagline, contains('25 mins'));
      expect(UserRole.artisan.localizedTagline, contains('IMPS'));
    });
  });
}
