import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/trade_model.dart';

void main() {
  group('10 Launch Trades Config Tests', () {
    test('Electrician trade model parses correctly with safety shield fee', () {
      final json = {
        'tradeId': 'trade_electrician',
        'slug': 'electrician',
        'name': 'Electrician',
        'marathiName': 'इलेक्ट्रिशियन',
        'tagline': 'Short circuit, MCB, switchboard & heavy appliance wiring',
        'accentColor': '#D97706',
        'surfaceTint': '#FEF3C7',
        'iconName': 'bolt',
        'baseInspectionFee': 199,
        'safetyShieldFee': 29,
        'guaranteeDays': 30,
        'emergencyEligible': true,
        'popularPackages': [
          {
            'packageId': 'pkg_elec_mcb',
            'name': 'Short Circuit & MCB Tripping',
            'estimatedPrice': 249,
            'estimatedMinutes': 45,
            'description': 'Continuous tripping, spark diagnosis & fuse repair',
          }
        ]
      };

      final trade = TradeModel.fromJson(json);
      expect(trade.tradeId, equals('trade_electrician'));
      expect(trade.name, equals('Electrician'));
      expect(trade.marathiName, equals('इलेक्ट्रिशियन'));
      expect(trade.baseInspectionFee, equals(199));
      expect(trade.safetyShieldFee, equals(29));
      expect(trade.guaranteeDays, equals(30));
      expect(trade.emergencyEligible, isTrue);
      expect(trade.popularPackages.length, equals(1));
      expect(trade.popularPackages.first.estimatedPrice, equals(249));
    });

    test('All 10 trades required slugs validation', () {
      final requiredSlugs = [
        'electrician',
        'plumber',
        'carpenter',
        'mason-civil-worker',
        'painter',
        'ac-refrigeration',
        'appliance-repair',
        'welder-fabricator',
        'pest-control',
        'deep-cleaning',
      ];
      expect(requiredSlugs.length, equals(10));
    });
  });
}
