import 'package:konstudy/controllers/profile/group/igroup_profil_controller.dart';
import 'package:konstudy/models/profile/group_profil.dart';
import 'package:konstudy/services/profile/group/igroup_profil_service.dart';

class GroupProfilController implements IGroupProfilController{
  final IGroupProfilService _service;

  GroupProfilController(this._service);

  @override
  Future<GroupProfil> fetchGroupProfile(String groupId) {
    return _service.fetchGroupProfile(groupId);
  }

}