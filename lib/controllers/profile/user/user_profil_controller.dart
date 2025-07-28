import 'package:konstudy/controllers/profile/user/iuser_profil_controller.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/services/profile/user/iuser_profil_service.dart';

class UserProfilController implements IUserProfilController {
  final IUserProfilService _service;

  UserProfilController(this._service);

  @override
  Future<UserProfil> fetchUserProfile({String? userId}) {
    return _service.fetchUserProfile(userId: userId);
  }

  @override
  Future<bool> deleteAccount() {
    return _service.deleteOwnAccount();
  }
}
