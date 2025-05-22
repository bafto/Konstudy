import 'package:konstudy/models/user_groups/group.dart';

abstract class IUserGroupsService {
  Future<List<Group>> fetchGroups();
  Future<void> createGroup(String name, String? description, List<String> gruppenmitglieder);
  Future<List<Map<String, dynamic>>> searchUsers(String query);
}
