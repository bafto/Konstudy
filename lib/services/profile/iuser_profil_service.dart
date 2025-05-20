import 'package:konstudy/models/profile/user_profil.dart';

abstract class IUserProfilService{
  Future<UserProfil> fetchUserProfile();
}