import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/artisan_profile_model.dart';

void main() {
  group('KarigaarRoleType Unit Tests across 10 Launch Trades', () {
    test('Rate multipliers match economic tier specifications', () {
      expect(KarigaarRoleType.headMistry.rateMultiplier, equals(1.25));
      expect(KarigaarRoleType.skilledKarigaar.rateMultiplier, equals(1.00));
      expect(KarigaarRoleType.helperAssistant.rateMultiplier, equals(0.65));
    });

    test('Standard labels and Marathi translations are correct', () {
      expect(KarigaarRoleType.headMistry.standardLabel, equals('Head Mistry / Ustad'));
      expect(KarigaarRoleType.headMistry.marathiLabel, equals('मुख्य मिस्त्री / उस्ताद'));
      expect(KarigaarRoleType.headMistry.badgeText, equals('👑 Head Mistry'));

      expect(KarigaarRoleType.skilledKarigaar.standardLabel, equals('Skilled Karigaar'));
      expect(KarigaarRoleType.skilledKarigaar.marathiLabel, equals('कुशल कारागीर'));
      expect(KarigaarRoleType.skilledKarigaar.badgeText, equals('🔧 Skilled Karigaar'));

      expect(KarigaarRoleType.helperAssistant.standardLabel, equals('Helper / Bigari'));
      expect(KarigaarRoleType.helperAssistant.marathiLabel, equals('हेल्पर / बिगारी'));
      expect(KarigaarRoleType.helperAssistant.badgeText, equals('🤝 Helper'));
    });

    test('1. Plumber (trade_plumber) localized titles', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_plumber'),
          equals('Plumbing Mistry (नळ मिस्त्री)'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_plumber'),
          equals('Sanitary & Pipeline Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('trade_plumber'),
          equals('Plumber Helper / Bigari'));
    });

    test('2. Mason (trade_mason) localized titles with alias normalization', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_mason'),
          equals('Raj Mistry / Head Gawandi (राज मिस्त्री / गवंडी)'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_mason_civil_worker'),
          equals('Tile & Plaster Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('mason'),
          equals('Bigari Helper'));
    });

    test('3. Electrician (trade_electrician) localized titles', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_electrician'),
          equals('Head Wireman Mistry (वायरमन मिस्त्री)'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_electrician'),
          equals('Line & Panel Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('trade_electrician'),
          equals('Electrical Helper'));
    });

    test('4. Carpenter (trade_carpenter) localized titles', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_carpenter'),
          equals('Sutar Mistry (सुतार मिस्त्री)'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_carpenter'),
          equals('Modular Furniture Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('trade_carpenter'),
          equals('Woodwork Helper'));
    });

    test('5. Painter (trade_painter) localized titles', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_painter'),
          equals('Rangari Mistry (रंगारी मिस्त्री)'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_painter'),
          equals('Putty & Texture Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('trade_painter'),
          equals('Sanding Helper'));
    });

    test('6. AC & Refrigeration localized titles across aliases', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_ac_refrig'),
          equals('Senior HVAC Mistry'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_ac'),
          equals('Gas & Cooling Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('trade_ac_repair'),
          equals('Duct/Unit Helper'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('trade_ac_refrigeration'),
          equals('Duct/Unit Helper'));
    });

    test('7. Appliance Repair localized titles across aliases', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_appliance'),
          equals('Master PCB & Motor Mistry'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_appliance_repair'),
          equals('Appliance Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('appliance'),
          equals('Diagnostic Helper'));
    });

    test('8. Welder & Fabricator (trade_welder) localized titles', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_welder'),
          equals('Fabrication Mistry (वेल्डिंग मिस्त्री)'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_welder_fabricator'),
          equals('Arc/TIG Welder Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('welder'),
          equals('Grinding Helper'));
    });

    test('9. Pest Control localized titles across aliases', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_pest'),
          equals('Senior Fumigation Mistry'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_pest_control'),
          equals('Chemical Spray Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('pest'),
          equals('Safety Helper'));
    });

    test('10. Deep Cleaning localized titles across aliases', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_cleaning'),
          equals('Cleaning Supervisor Mistry'));
      expect(KarigaarRoleType.skilledKarigaar.getLocalizedTitle('trade_deep_cleaning'),
          equals('Machine Scrubbing Karigaar'));
      expect(KarigaarRoleType.helperAssistant.getLocalizedTitle('cleaning'),
          equals('Sanitation Helper'));
    });

    test('Unknown trade fallback to standardLabel', () {
      expect(KarigaarRoleType.headMistry.getLocalizedTitle('trade_unknown'),
          equals('Head Mistry / Ustad'));
    });

    test('fromString parsing handles diverse inputs', () {
      expect(KarigaarRoleType.fromString('mistry'), equals(KarigaarRoleType.headMistry));
      expect(KarigaarRoleType.fromString('Head Wireman'), equals(KarigaarRoleType.headMistry));
      expect(KarigaarRoleType.fromString('Ustad'), equals(KarigaarRoleType.headMistry));
      expect(KarigaarRoleType.fromString('Senior Specialist'), equals(KarigaarRoleType.headMistry));
      expect(KarigaarRoleType.fromString('Supervisor'), equals(KarigaarRoleType.headMistry));

      expect(KarigaarRoleType.fromString('helper'), equals(KarigaarRoleType.helperAssistant));
      expect(KarigaarRoleType.fromString('Bigari'), equals(KarigaarRoleType.helperAssistant));
      expect(KarigaarRoleType.fromString('assistant'), equals(KarigaarRoleType.helperAssistant));

      expect(KarigaarRoleType.fromString(null), equals(KarigaarRoleType.skilledKarigaar));
      expect(KarigaarRoleType.fromString('karigaar'), equals(KarigaarRoleType.skilledKarigaar));
      expect(KarigaarRoleType.fromString('random_text'), equals(KarigaarRoleType.skilledKarigaar));
    });

    test('GuildTier commission restructuring replaces 0% margin with 5% floor', () {
      expect(GuildTier.registered.commissionRate, equals(0.15));
      expect(GuildTier.guildVerifiedPro.commissionRate, equals(0.12));
      expect(GuildTier.masterGuildsman.commissionRate, equals(0.08));
      expect(GuildTier.guildElite.commissionRate, equals(0.05));

      expect(GuildTier.masterGuildsman.label, contains('8% Commission'));
      expect(GuildTier.guildElite.label, contains('5% Commission Floor'));
    });

    test('ArtisanProfileModel effectiveCommissionRate and role integration', () {
      const artisan = ArtisanProfileModel(
        artisanId: 'art_test_01',
        name: 'Ganesh Kadam',
        phone: '+919822012345',
        primaryTradeId: 'trade_electrician',
        tradeTitle: 'Master Electrician',
        yearsExperience: 10,
        rating: 4.9,
        reviewCount: 300,
        distanceKm: 1.5,
        bio: 'Expert electrician',
        inspectionFee: 199,
        cityId: 'city_nanded_01',
        localityId: 'loc_anand_nagar',
        tier: GuildTier.masterGuildsman,
        roleType: KarigaarRoleType.headMistry,
        isGuildElite: false,
      );

      expect(artisan.roleType, equals(KarigaarRoleType.headMistry));
      expect(artisan.localizedRoleTitle, equals('Head Wireman Mistry (वायरमन मिस्त्री)'));
      expect(artisan.roleBadgeLabel, equals('Head Mistry / Ustad'));
      expect(artisan.effectiveCommissionRate, equals(0.08));
      expect(artisan.isCommissionFloorEligible, isTrue);
      expect(artisan.isZeroCommissionEligible, isTrue); // backwards-compatible alias

      const eliteArtisan = ArtisanProfileModel(
        artisanId: 'art_test_02',
        name: 'Sayyed Arshad',
        phone: '+919822054321',
        primaryTradeId: 'trade_plumber',
        tradeTitle: 'Plumber',
        yearsExperience: 8,
        rating: 4.8,
        reviewCount: 200,
        distanceKm: 2.0,
        bio: 'Expert plumber',
        inspectionFee: 199,
        cityId: 'city_nanded_01',
        localityId: 'loc_vazirabad',
        tier: GuildTier.guildVerifiedPro,
        roleType: KarigaarRoleType.skilledKarigaar,
        isGuildElite: true,
      );

      expect(eliteArtisan.effectiveCommissionRate, equals(0.05));
      expect(eliteArtisan.isCommissionFloorEligible, isTrue);
    });
  });
}
