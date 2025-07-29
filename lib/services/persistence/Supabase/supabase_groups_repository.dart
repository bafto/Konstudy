import 'package:konstudy/models/profile/group_profil.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/services/persistence/igroups_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/profile/user_profil.dart';

class SupabaseGroupRepository implements IGroupRepository {
  final SupabaseClient _client;

  SupabaseGroupRepository(this._client);

  @override
  Future<List<Group>> getGroupsForUser(String userId) async {
    final groupIdResult = await _client
        .from('group_members')
        .select('group_id')
        .eq('user_id', userId);

    final groupIds = (groupIdResult as List)
        .map((e) => e['group_id'] as String)
        .toList();

    if (groupIds.isEmpty) return [];

    final groupData = await _client
        .from('groups')
        .select('*, group_members(*)')
        .inFilter('id', groupIds);

    return List<Group>.from(
      (groupData as List).map((e) => Group.fromJson(e as Map<String, dynamic>)),
    );
  }

  @override
  Future<Group> getGroupById(String id) async {
    final group = await _client
        .from('groups')
        .select('*')
        .eq('id', id)
        .single();

    final members = await _client
        .from('group_members')
        .select()
        .eq('group_id', id);

    group['group_members'] = members;

    return Group.fromJson(group);
  }

  @override
  Future<Group> createGroup({
    required String name,
    String? description,
    required String createdByUserId,
    required List<String> members,
  }) async {
    final response = await _client
        .from('groups')
        .insert({
      'name': name,
      'description': description,
      'created_by': createdByUserId,
    })
        .select()
        .single();

    final groupId = response['id'] as String;

    // Ersteller als Admin hinzufügen
    await _client.from('group_members').insert({
      'group_id': groupId,
      'user_id': createdByUserId,
      'is_admin': true,
    });

    // Andere Mitglieder hinzufügen
    for (final userId in members.where((id) => id != createdByUserId)) {
      await _client.from('group_members').insert({
        'group_id': groupId,
        'user_id': userId,
      });
    }

    final allMembers = await _client
        .from('group_members')
        .select()
        .eq('group_id', groupId);

    response['group_members'] = allMembers;

    return Group.fromJson(response);
  }

  @override
  Future<void> addUserToGroup({
    required String userId,
    required String groupId,
  }) async {
    await _client.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
    });
  }

  @override
  Future<void> removeUserFromGroup({
    required String userId,
    required String groupId,
  }) async {
    await _client
        .from('group_members')
        .delete()
        .eq('user_id', userId)
        .eq('group_id', groupId);
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await _client.from('groups').delete().eq('id', groupId);
  }

  @override
  Future<GroupProfil> fetchGroupProfile(String groupId, String currentUserId) async{
    final response = await _client
        .from('groups')
        .select('''
          name,
          description,
          profile_image_url,
          group_members (
            users (
              id,
              name,
              email,
              description,
              avatar_url
            )
          )
        ''')
        .eq('id', groupId)
        .single();

    final memberData = response['group_members'] as List<dynamic>? ?? [];

    final members = memberData.map((entry) {
      final user = entry['users'];
      return UserProfil(
        id: user['id'] as String,
        name: user['name'] as String,
        email: user['email'] as String,
        description: user['description'] as String?,
        profileImageUrl: user['avatar_url'] as String?, // korrigiert
      );
    }).toList();

    final adminData = await _client
        .from('group_members')
        .select('is_admin')
        .eq('group_id', groupId)
        .eq('user_id', currentUserId)
        .single();

    final isAdmin = adminData['is_admin'] as bool;

    return GroupProfil(
      name: response['name'] as String,
      description: response['description'] as String?,
      imageUrl: response['profile_image_url'] as String?, // korrigiert
      members: members,
      isCurrentUserAdmin: isAdmin,
    );;
  }

}
