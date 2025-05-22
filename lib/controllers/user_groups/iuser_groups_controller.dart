import 'package:konstudy/models/user_groups/group.dart';

abstract class IUserGroupsController {
  Future<List<Group>> getGroups();
}
