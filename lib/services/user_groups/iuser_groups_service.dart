import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/models/user_groups/group.dart';

abstract class IUserGroupsService {
  Future<List<Group>> fetchGroups();
  Future<Group> createGroup(
    String name,
    String? description,
    List<String> gruppenmitglieder,
  );
  Future<List<UserProfil>> searchUsers(String query);
}
