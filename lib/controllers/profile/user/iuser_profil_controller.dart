import 'package:konstudy/models/profile/user_profil.dart';

abstract class IUserProfilController {
  Future<UserProfil> fetchUserProfile({String? userId});
  Future<UserProfil> fetchUserProfileById({required String id});
}
