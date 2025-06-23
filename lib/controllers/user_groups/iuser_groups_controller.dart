import 'package:flutter/foundation.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/models/user_groups/group.dart';

abstract class IUserGroupsController extends ChangeNotifier {
  Future<List<Group>> getGroups();
  List<UserProfil> get searchResult;
  List<UserProfil> get selectedUsers;
  Future<Group> groupCreate({required String name, String? beschreibung});
  Future<void> searchUser(String query);
  void addUser(UserProfil user);
  void removeUser(UserProfil user);
  void removeAllUsers();
}
