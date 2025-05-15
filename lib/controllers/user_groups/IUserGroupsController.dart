import 'package:konstudy/models/user_groups/group.dart';

abstract class IUserGroupsController {
  List<Group> get groups;
  Future<void> loadGroups();
}
