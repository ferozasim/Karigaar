// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get languageSetting => 'App language';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get marathi => 'मराठी';

  @override
  String get searchServices => 'Search by job, material, or trade';

  @override
  String get browseServices => 'Browse services';

  @override
  String get allTrades => 'All services';

  @override
  String get explore => 'Explore';

  @override
  String get bookings => 'Bookings';

  @override
  String get messages => 'Messages';

  @override
  String get profile => 'Profile';

  @override
  String get quickServiceSearch => 'Find a service';

  @override
  String get selectServicePrompt =>
      'What do you need help with? Search a task like tiles, granite, or plumbing.';

  @override
  String inspectionWarranty(Object fee, Object days) {
    return 'Inspection ₹$fee • $days day warranty';
  }

  @override
  String get noServicesFound =>
      'No matching service found. Try another task or trade.';
}
