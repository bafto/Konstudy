import 'package:konstudy/models/profile/group_profil.dart';

abstract class IGroupProfilController{
  Future<GroupProfil> fetchGroupProfile(String groupId);
}