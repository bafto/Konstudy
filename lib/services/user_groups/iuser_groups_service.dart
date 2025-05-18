import 'package:konstudy/models/user_groups/group.dart';

abstract class IUserGroupsService {
  Future<List<Group>> fetchGroups();
}
