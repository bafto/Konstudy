import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/services/persistence/iusers_repository.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';

import '../auth/iauth_service.dart';
import '../persistence/igroups_repository.dart';


class UserGroupsService implements IUserGroupsService {
  final IUserRepository _userRepository;
  final IGroupRepository _groupRepository;
  final IAuthService _authService;  // Abstraktion für Auth

  UserGroupsService(this._userRepository, this._groupRepository, this._authService);

  @override
  Future<List<Group>> fetchGroups() async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      throw Exception('Kein eingeloggter Benutzer');
    }
    return _groupRepository.getGroupsForUser(userId);
  }

  @override
  Future<Group> getGroupById(String id) async {
    return _groupRepository.getGroupById(id);
  }

  @override
  Future<Group> createGroup(
      String name,
      String? description,
      List<String> gruppenmitglieder,
      ) async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      throw Exception('Kein eingeloggter Benutzer');
    }

    return _groupRepository.createGroup(
      name: name,
      description: description,
      createdByUserId: userId,
      members: gruppenmitglieder,
    );
  }

  @override
  Future<List<UserProfil>> searchUsers(String query) async {
    if (query.isEmpty) return [];
    return _userRepository.searchUsers(query);
  }

  @override
  Future<void> deleteGroup(String id) {
    return _groupRepository.deleteGroup(id);
  }

  @override
  Future<void> removeUserFromGroup(String userId, String groupId) {
    return _groupRepository.removeUserFromGroup(userId: userId, groupId: groupId);
  }

  @override
  Future<void> addUserToGroup({required String userId, required String groupId}) {
    return _groupRepository.addUserToGroup(userId: userId, groupId: groupId);
  }
}
