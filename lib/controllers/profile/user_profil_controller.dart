import 'package:konstudy/controllers/profile/iuser_profil_controller.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/services/profile/iuser_profil_service.dart';

class UserProfilController implements IUserProfilController {
  final IUserProfilService _service;

  UserProfilController(this._service);

  @override
  Future<UserProfil> fetchUserProfile() {
    return _service.fetchUserProfile();
  }
}
