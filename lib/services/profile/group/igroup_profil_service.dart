import 'package:konstudy/models/profile/group_profil.dart';

abstract class IGroupProfilService {
  Future<GroupProfil> fetchGroupProfile(String groupId);
}
