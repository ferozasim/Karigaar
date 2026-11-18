import '../models/trade_model.dart';

/// Search aliases that help homeowners find work by the job they need done,
/// even when the underlying provider trade has a different name.
class ServiceDiscoveryCatalog {
  ServiceDiscoveryCatalog._();

  static const Map<String, List<String>> _aliasesByTrade = {
    'trade_mason': [
      'tile',
      'tiles',
      'floor tile',
      'wall tile',
      'granite',
      'marble',
      'stone',
      'flooring',
      'grouting',
      'masonry',
      'civil work',
      'गवंडी',
      'फरशी',
      'टाइल',
      'ग्रॅनाइट',
      'मार्बल',
      'मिस्त्री',
      'राजमिस्त्री',
      'फर्श',
      'ग्रेनाइट',
      'संगमरमर',
      'पत्थर',
    ],
    'trade_electrician': [
      'wiring',
      'switch',
      'socket',
      'fan',
      'mcb',
      'short circuit',
      'इलेक्ट्रिशियन',
    ],
    'trade_plumber': [
      'leak',
      'tap',
      'pipe',
      'drain',
      'toilet',
      'sink',
      'नळ',
      'प्लंबर',
    ],
    'trade_carpenter': [
      'door',
      'lock',
      'furniture',
      'wardrobe',
      'hinge',
      'सुतार',
    ],
  };

  static String localizedTradeName(TradeModel trade, String languageCode) {
    if (languageCode == 'mr') return trade.marathiName;
    if (languageCode != 'hi') return trade.name;
    return const {
          'trade_electrician': 'इलेक्ट्रीशियन',
          'trade_plumber': 'प्लंबर',
          'trade_carpenter': 'बढ़ई',
          'trade_mason': 'राजमिस्त्री / सिविल कारीगर',
          'trade_painter': 'पेंटर',
          'trade_ac_refrig': 'एसी और फ्रिज मैकेनिक',
          'trade_appliance': 'घरेलू उपकरण मरम्मत',
          'trade_welder': 'वेल्डर / फैब्रिकेटर',
          'trade_pest': 'कीट नियंत्रण',
          'trade_deep_cleaning': 'डीप क्लीनिंग',
        }[trade.tradeId] ??
        trade.name;
  }

  static String serviceLabel(
      TradeModel trade, String query, String languageCode) {
    final normalized = _normalize(query);
    if (trade.tradeId == 'trade_mason') {
      final isStone = normalized.contains('granite') ||
          normalized.contains('marble') ||
          normalized.contains('stone') ||
          normalized.contains('ग्रॅनाइट') ||
          normalized.contains('मार्बल') ||
          normalized.contains('ग्रेनाइट') ||
          normalized.contains('संगमरमर') ||
          normalized.contains('पत्थर');
      final isTile = normalized.contains('tile') ||
          normalized.contains('floor') ||
          normalized.contains('फरशी') ||
          normalized.contains('टाइल') ||
          normalized.contains('फर्श');
      if (isStone) {
        return switch (languageCode) {
          'hi' => 'ग्रेनाइट, संगमरमर और पत्थर का काम',
          'mr' => 'ग्रॅनाइट, मार्बल आणि दगडाचे काम',
          _ => 'Granite, marble & stone work',
        };
      }
      if (isTile) {
        return switch (languageCode) {
          'hi' => 'टाइल मरम्मत और फर्श',
          'mr' => 'टाइल दुरुस्ती आणि फरशी',
          _ => 'Tile repair & flooring',
        };
      }
    }
    if (languageCode != 'en') return localizedTradeName(trade, languageCode);
    for (final package in trade.popularPackages) {
      final text = _normalize('${package.name} ${package.description}');
      if (normalized.isNotEmpty && normalized.split(' ').any(text.contains)) {
        return package.name;
      }
    }
    return localizedTradeName(trade, languageCode);
  }

  static List<TradeModel> search(List<TradeModel> trades, String query) {
    final normalized = _normalize(query);
    if (normalized.isEmpty) return trades;

    final terms =
        normalized.split(' ').where((term) => term.isNotEmpty).toList();
    final scored = <({TradeModel trade, int score})>[];
    for (final trade in trades) {
      final searchable = <String>[
        trade.name,
        trade.marathiName,
        trade.tagline,
        ...trade.popularPackages
            .expand((package) => [package.name, package.description]),
        ...?_aliasesByTrade[trade.tradeId],
      ].map(_normalize).join(' ');
      final score = terms.fold<int>(0, (total, term) {
        if (trade.name.toLowerCase().contains(term)) return total + 4;
        return searchable.contains(term) ? total + 1 : total;
      });
      if (score > 0) scored.add((trade: trade, score: score));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((result) => result.trade).toList();
  }

  static String _normalize(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
}
