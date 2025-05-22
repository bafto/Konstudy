import 'package:flutter/foundation.dart';
import 'package:konstudy/models/user_groups/group.dart';

abstract class IUserGroupsController extends ChangeNotifier {
  Future<List<Group>> getGroups();
  Future<Group> addGroup(Group g);
}
