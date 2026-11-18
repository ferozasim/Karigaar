import 'user_role.dart';

/// Persisted account identity. It deliberately contains no OTP, token, or KYC
/// document data; those remain in their respective secure services.
class UserProfileModel {
  final String userId;
  final String displayName;
  final String phone;
  final UserRole activeRole;
  final String cityId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileModel({
    required this.userId,
    required this.displayName,
    required this.phone,
    required this.activeRole,
    required this.cityId,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfileModel copyWith({
    String? displayName,
    String? phone,
    UserRole? activeRole,
    String? cityId,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      userId: userId,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      activeRole: activeRole ?? this.activeRole,
      cityId: cityId ?? this.cityId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'displayName': displayName,
        'phone': phone,
        'activeRole': activeRole.name,
        'cityId': cityId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      phone: json['phone'] as String,
      activeRole: UserRole.values.firstWhere(
        (role) => role.name == json['activeRole'],
        orElse: () => UserRole.customer,
      ),
      cityId: json['cityId'] as String? ?? 'city_nanded_01',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
