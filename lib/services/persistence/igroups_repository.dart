import 'package:konstudy/models/user_groups/group.dart';

import '../../models/profile/group_profil.dart';

abstract class IGroupRepository {
  Future<List<Group>> getGroupsForUser(String userId);
  Future<Group> getGroupById(String id);
  Future<Group> createGroup({
    required String name,
    String? description,
    required String createdByUserId,
    required List<String> members,
  });
  Future<void> addUserToGroup({required String userId, required String groupId});
  Future<void> removeUserFromGroup({required String userId, required String groupId});
  Future<void> deleteGroup(String groupId);
  Future<GroupProfil> fetchGroupProfile(String groupId, String currentUserId);
}
