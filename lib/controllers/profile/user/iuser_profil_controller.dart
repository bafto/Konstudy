import 'package:konstudy/models/profile/user_profil.dart';

abstract class IUserProfilController {
  Future<UserProfil> fetchUserProfile({String? userId});
  Future<bool> deleteAccount();
  Future<void> updateUserProfil({required String userId, String? name, String? description, String? profileImageUrl});
}
