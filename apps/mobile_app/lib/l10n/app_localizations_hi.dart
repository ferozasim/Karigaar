// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get languageName => 'हिन्दी';

  @override
  String get languageSetting => 'ऐप की भाषा';

  @override
  String get chooseLanguage => 'अपनी भाषा चुनें';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get marathi => 'मराठी';

  @override
  String get searchServices => 'काम, सामग्री या कारीगर खोजें';

  @override
  String get browseServices => 'सेवाएँ देखें';

  @override
  String get allTrades => 'सभी सेवाएँ';

  @override
  String get explore => 'खोजें';

  @override
  String get bookings => 'बुकिंग';

  @override
  String get messages => 'संदेश';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get quickServiceSearch => 'सेवा खोजें';

  @override
  String get selectServicePrompt =>
      'आपको किस काम में मदद चाहिए? टाइल, ग्रेनाइट या प्लंबिंग खोजें।';

  @override
  String inspectionWarranty(Object fee, Object days) {
    return 'जांच ₹$fee • $days दिन की वारंटी';
  }

  @override
  String get noServicesFound =>
      'कोई सेवा नहीं मिली। दूसरा काम या कारीगर खोजें।';
}
