import 'package:flutter/foundation.dart';
import 'package:konstudy/controllers/user_groups/iuser_groups_controller.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserGroupsControllerImpl extends ChangeNotifier
    implements IUserGroupsController {
  final IUserGroupsService _service;

  UserGroupsControllerImpl(this._service);

  List<Map<String, dynamic>> searchResult = [];
  List<Map<String, dynamic>> selectedUsers = [];

  @override
  Future<List<Group>> getGroups() => _service.fetchGroups();

  @override
  Future<bool> groupCreate({
    required String name,
    String? beschreibung,
  }) async {
    if(name.isEmpty){
      return false;
    }

    final userIds = selectedUsers.map((u) => u['id'] as String).toList();
    await _service.createGroup(name, beschreibung, userIds);

    selectedUsers.clear();
    searchResult.clear();
    notifyListeners();
    return true;
  }

  @override
  Future<void> searchUser(String query) async{
    searchResult = await _service.searchUsers(query);
    notifyListeners();
  }

  @override
  void addUser(Map<String, dynamic> user) {
    if(!selectedUsers.any((n) => n['id'] == user['id'])){
      selectedUsers.add(user);
      notifyListeners();
    }
  }

  @override
  void removeUser(Map<String, dynamic> user) {
    selectedUsers.removeWhere((n) => n['id'] == user['id']);
    notifyListeners();
  }

}
