abstract class AppConstants {
  static const String appName = 'Karigaar';
  static const String appTagline = 'Master Guildsman Meets Modern Concierge';

  // Pilot City: Nanded, Maharashtra
  static const String defaultCityId = 'city_nanded_01';
  static const String defaultCityName = 'Nanded';
  static const String defaultCityState = 'Maharashtra';
  static const double defaultLatitude = 19.1383;
  static const double defaultLongitude = 77.3210;

  // Timers & SLAs
  static const int emergencyDispatchWindowMins = 25;
  static const int radarCountdownSeconds = 45;
  static const int otpResendCountdownSeconds = 42;
  static const int maxScopingAudioSeconds = 15;
  static const int cancellationFreeMinutes = 3;

  // Pricing & Safety Shield
  static const int safetyShieldFee = 29;
  static const int standardGuaranteeDays = 30;
  static const int transitCancellationFee = 99;
  static const int maxGuildDamageGuarantee = 25000;

  // Fixed Security Start Code (Homeowner shows to Artisan on arrival)
  static const String defaultSecurityStartCode = '4921';

  // Firebase
  static const String firebaseProjectId = 'karigaar-ba812';
}
