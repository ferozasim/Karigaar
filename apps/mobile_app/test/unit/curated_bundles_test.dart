import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/preventive_bundle_model.dart';
import 'package:karigaar_app/core/config/app_data_service.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';

void main() {
  group('PreventiveBundleModel Unit Tests (F-08)', () {
    test('1. Model computes correct savings amount and discount percentage', () {
      const bundle = PreventiveBundleModel(
        bundleId: 'bundle_monsoon_elec',
        title: 'Monsoon Electrical Shield',
        marathiTitle: 'पावसाळी विद्युत सुरक्षा',
        subtitle: 'Prevent short circuits & water-contact shocks',
        tradeId: 'trade_electrician',
        originalPrice: 699,
        discountedPrice: 499,
        discountTag: 'SAVE 28%',
        includedPackageIds: ['pkg_elec_mcb', 'pkg_elec_switchboard', 'pkg_elec_fan'],
        includedTasks: ['MCB test', 'Earthing check', 'Switchboard wiring'],
        estimatedMinutes: 60,
        badgeText: 'Monsoon Ready',
        iconName: 'bolt',
        accentColorHex: '#D97706',
        surfaceTintHex: '#FEF3C7',
        guaranteeDays: 30,
      );

      expect(bundle.savingsAmount, 200);
      expect(bundle.computedDiscountPercent, 29); // 200/699 = 28.6% -> rounds to 29%
      expect(bundle.guaranteeDays, 30);
      expect(bundle.accentColor.toARGB32(), isNotNull);
      expect(bundle.surfaceTint.toARGB32(), isNotNull);
    });

    test('2. Serialization to JSON and round-trip fromJson restoration', () {
      const original = PreventiveBundleModel(
        bundleId: 'bundle_plumb_health',
        title: 'Full Home Plumbing Health Check',
        marathiTitle: 'घरगुती प्लंबिंग आरोग्य तपासणी',
        subtitle: 'Seepage scan, overhead tank valve test & trap unclogging',
        tradeId: 'trade_plumber',
        originalPrice: 649,
        discountedPrice: 459,
        discountTag: 'SAVE 29%',
        includedPackageIds: ['pkg_plumb_leak', 'pkg_plumb_drain', 'pkg_plumb_tap'],
        includedTasks: ['Leak scan', 'Drain unclog', 'Tap tune-up'],
        estimatedMinutes: 55,
        badgeText: 'Prevent Seepage',
        iconName: 'plumbing',
        accentColorHex: '#0284C7',
        surfaceTintHex: '#E0F2FE',
        guaranteeDays: 30,
      );

      final json = original.toJson();
      expect(json['bundleId'], 'bundle_plumb_health');
      expect(json['originalPrice'], 649);
      expect(json['discountedPrice'], 459);
      expect(json['savingsAmount'], 190);
      expect(json['includedPackageIds'], ['pkg_plumb_leak', 'pkg_plumb_drain', 'pkg_plumb_tap']);

      final restored = PreventiveBundleModel.fromJson(json);
      expect(restored.bundleId, original.bundleId);
      expect(restored.title, original.title);
      expect(restored.originalPrice, original.originalPrice);
      expect(restored.discountedPrice, original.discountedPrice);
      expect(restored.savingsAmount, 190);
      expect(restored.includedPackageIds, original.includedPackageIds);
      expect(restored.includedTasks, original.includedTasks);
    });

    test('3. AppDataService curated bundles catalog has 4 regional packages with valid trades', () {
      final bundles = AppDataService.getCuratedBundles();
      expect(bundles.length, 4);

      final bundleIds = bundles.map((b) => b.bundleId).toList();
      expect(bundleIds, containsAll([
        'bundle_monsoon_elec',
        'bundle_plumb_health',
        'bundle_ac_summer',
        'bundle_carpenter_care',
      ]));

      for (final bundle in bundles) {
        expect(bundle.discountedPrice, lessThan(bundle.originalPrice));
        expect(bundle.savingsAmount, greaterThan(0));
        expect(bundle.computedDiscountPercent, greaterThanOrEqualTo(25));
        expect(bundle.includedPackageIds, isNotEmpty);
        expect(bundle.includedTasks, isNotEmpty);
        expect(bundle.title, isNotEmpty);
        expect(bundle.marathiTitle, isNotEmpty);
      }
    });

    test('4. curatedBundlesProvider serves catalog through Riverpod container', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final bundles = container.read(curatedBundlesProvider);
      expect(bundles.length, 4);
      expect(bundles.first.bundleId, 'bundle_monsoon_elec');
    });
  });
}
