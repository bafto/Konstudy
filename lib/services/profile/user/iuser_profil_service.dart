import 'package:konstudy/models/profile/user_profil.dart';

abstract class IUserProfilService {
  Future<UserProfil> fetchUserProfile({String? userId});
  Future<bool> deleteOwnAccount();
  Future<void> updateUserProfile(UserProfil profil);
}
