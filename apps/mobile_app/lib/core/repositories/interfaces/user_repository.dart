import '../../models/user_profile_model.dart';
import '../../models/user_role.dart';

abstract interface class IUserRepository {
  Future<UserProfileModel?> getById(String userId);
  Future<void> save(UserProfileModel user);
  Future<void> updateRole(String userId, UserRole role);
  Stream<UserProfileModel?> streamUser(String userId);
}
