import 'package:flutter/foundation.dart';
import 'package:konstudy/controllers/user_groups/iuser_groups_controller.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';

class UserGroupsControllerImpl extends ChangeNotifier
    implements IUserGroupsController {
  final IUserGroupsService _service;

  UserGroupsControllerImpl(this._service);

  @override
  List<UserProfil> searchResult = [];
  @override
  List<UserProfil> selectedUsers = [];

  @override
  Future<List<Group>> getGroups() => _service.fetchGroups();

  @override
  Future<Group> getGroupById(String id) {
    return _service.getGroupById(id);
  }

  @override
  Future<Group> groupCreate({
    required String name,
    String? beschreibung,
  }) async {
    if (name.isEmpty) {
      return Future.error("Name darf nicht leer sein");
    }

    final userIds = selectedUsers.map((u) => u.id).toList();
    try {
      return await _service.createGroup(name, beschreibung, userIds);
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    } finally {
      selectedUsers.clear();
      searchResult.clear();
      notifyListeners();
    }
  }

  @override
  Future<void> searchUser(String query) async {
    searchResult = await _service.searchUsers(query);
  }

  @override
  void addUser(UserProfil user) {
    if (!selectedUsers.any((n) => n.id == user.id)) {
      selectedUsers.add(user);
      notifyListeners();
    }
  }

  @override
  void removeUser(UserProfil user) {
    selectedUsers.removeWhere((n) => n.id == user.id);
    notifyListeners();
  }

  @override
  removeAllUsers() {
    selectedUsers.clear();
    notifyListeners();
  }

  @override
  void addUserToGroup({required String userId, required String groupId}) async {
    await _service.addUserToGroup(userId: userId, groupId: groupId);
    notifyListeners();
  }

  @override
  void deleteGroup(String id) async {
    await _service.deleteGroup(id);
    notifyListeners();
  }

  @override
  void removeUserFromGroup(String userId, String groupId) async {
    await _service.removeUserFromGroup(userId, groupId);
    notifyListeners();
  }
}
