// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get languageName => 'मराठी';

  @override
  String get languageSetting => 'अॅपची भाषा';

  @override
  String get chooseLanguage => 'तुमची भाषा निवडा';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get marathi => 'मराठी';

  @override
  String get searchServices => 'काम, साहित्य किंवा कारागीर शोधा';

  @override
  String get browseServices => 'सेवा पाहा';

  @override
  String get allTrades => 'सर्व सेवा';

  @override
  String get explore => 'शोधा';

  @override
  String get bookings => 'बुकिंग्ज';

  @override
  String get messages => 'संदेश';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get quickServiceSearch => 'सेवा शोधा';

  @override
  String get selectServicePrompt =>
      'तुम्हाला कोणत्या कामासाठी मदत हवी आहे? टाइल, ग्रॅनाइट किंवा प्लंबिंग शोधा.';

  @override
  String inspectionWarranty(Object fee, Object days) {
    return 'तपासणी ₹$fee • $days दिवसांची वॉरंटी';
  }

  @override
  String get noServicesFound =>
      'जुळणारी सेवा सापडली नाही. दुसरे काम किंवा व्यवसाय शोधा.';
}
