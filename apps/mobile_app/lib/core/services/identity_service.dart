import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/artisan_onboarding.dart';

class VerifiedPhoneIdentity {
  const VerifiedPhoneIdentity({
    required this.userId,
    required this.phone,
    this.isArtisanApproved = false,
  });
  final String userId;
  final String phone;

  /// Must be populated by a trusted auth/custom-claims adapter. The local
  /// development stub always leaves this false.
  final bool isArtisanApproved;
}

abstract interface class IPhoneIdentityService {
  String get modeLabel;
  Future<void> requestCode(String phone);
  Future<VerifiedPhoneIdentity?> verifyCode(String phone, String code);
}

/// Explicit local development stub. It never represents provider-verified
/// identity and must be replaced by the Firebase Phone Auth adapter for live use.
class DevelopmentPhoneIdentityService implements IPhoneIdentityService {
  const DevelopmentPhoneIdentityService();

  static const developmentCode = '123456';
  static String localUserIdForPhone(String phone) =>
      'dev_phone_${phone.replaceAll(RegExp(r'\D'), '')}';
  @override
  String get modeLabel => 'Development sign-in stub • code 123456';

  @override
  Future<void> requestCode(String phone) async {}

  @override
  Future<VerifiedPhoneIdentity?> verifyCode(String phone, String code) async {
    if (code != developmentCode) return null;
    final normalized = phone.replaceAll(RegExp(r'\D'), '');
    if (normalized.length != 10) return null;
    // Stable phone-derived identity means a returning artisan resolves to the
    // same user ID rather than creating another profile on every login.
    return VerifiedPhoneIdentity(
      userId: localUserIdForPhone(normalized),
      phone: '+91$normalized',
    );
  }
}

class ArtisanOnboardingStore {
  const ArtisanOnboardingStore();

  String _key(String userId) => 'artisan_onboarding_$userId';

  Future<ArtisanOnboardingDraft?> read(String userId) async {
    final raw = (await SharedPreferences.getInstance()).getString(_key(userId));
    if (raw == null) return null;
    try {
      return ArtisanOnboardingDraft.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  Future<void> save(ArtisanOnboardingDraft draft) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
        _key(draft.userId), ArtisanOnboardingDraft.encode(draft));
  }
}
