import 'package:flutter/foundation.dart';
import 'package:konstudy/models/user_groups/group.dart';

abstract class IUserGroupsController extends ChangeNotifier {
  Future<List<Group>> getGroups();
  Future<Group> addGroup(Group g);
abstract class IUserGroupsController extends ChangeNotifier {
  List<Group> get groups;
  List<Map<String, dynamic>> get searchResult;
  List<Map<String, dynamic>> get selectedUsers;
  Future<void> loadGroups();
  Future<bool> groupCreate({required String name, String? beschreibung});
  Future<void> searchUser(String query);
  void addUser(Map<String, dynamic> user);
  void removeUser(Map<String, dynamic> user);
}
