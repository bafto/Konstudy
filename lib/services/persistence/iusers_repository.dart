
import '../../models/profile/user_profil.dart';

abstract class IUserRepository {
  Future<List<UserProfil>> searchUsers(String query);
  Future<UserProfil> fetchUserProfil(String userId);
  Future<void> updateUserProfil({
    required String userId,
    String? name,
    String? description,
    String? profileImageUrl,
  });
  Future<bool> deleteOwnAccount(String jwtToken);
}