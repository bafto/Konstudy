import 'package:flutter/foundation.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/models/user_groups/group_member.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserGroupsService implements IUserGroupsService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Group>> fetchGroups() async {
    final userId = _client.auth.currentUser!.id;

    //1. Hole die group_ids des Nutzers
    final groupIdResult = await _client
        .from('group_members')
        .select('group_id')
        .eq('user_id', userId);

    //2. Extrahiere die Ids
    final groupIds =
        (groupIdResult as List).map((e) => e['group_id'] as String).toList();

    if (groupIds.isEmpty) {
      return [];
    }

    // 3. Hole die vollständigen Gruppen
    final groupData = await _client
        .from('groups')
        .select('*, group_members(*)')
        .inFilter('id', groupIds);

    // 4. Daten in Group umwandeln
    return List<Group>.from(
      (groupData as List).map((e) => Group.fromJson(e as Map<String, dynamic>)),
    );
  }

  @override
  Future<Group> getGroupById(String id) async {
    final response =
        await _client.from('groups').select('*').eq('id', id).single();

    final members = await _client
        .from('group_members')
        .select()
        .eq('group_id', id);

    response['group_members'] = members;
    return Group.fromJson(response);
  }

  @override
  Future<Group> createGroup(
    String name,
    String? description,
    List<String> gruppenmitglieder,
  ) async {
    final members = gruppenmitglieder.toSet();

    final response =
        await _client
            .from('groups')
            .insert({
              'name': name,
              'description': description,
              'created_by': _client.auth.currentUser!.id,
            })
            .select()
            .single();

    final createdId = response['id'] as String;
    response['group_members'] =
        members
            .map((g) => GroupMember(userId: g, groupId: createdId).toJson())
            .toList();
    debugPrint(response.toString());
    final createdGroup = Group.fromJson(response);

    await _client.from('group_members').insert({
      'group_id': createdGroup.id,
      'user_id': _client.auth.currentUser!.id,
      'is_admin': true,
    });

    if (members.isNotEmpty) {
      for (final id in members.where(
        (m) => m != _client.auth.currentUser!.id,
      )) {
        await _client.from('group_members').insert({
          'group_id': createdGroup.id,
          'user_id': id,
        });
      }
    }

    return createdGroup;
  }

  @override
  Future<List<UserProfil>> searchUsers(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final data = await _client
          .from('users')
          .select('id, name, email')
          .ilike('name', '%$query%')
          .limit(10);

      return data.map(UserProfil.fromJson).toList();
    } catch (error) {
      // Optional: Logging oder Error-Handling
      throw Exception('Fehler bei der Nutzersuche: $error');
    }
  }

  @override
  Future<void> addUserToGroup({
    required String userId,
    required String groupId,
  }) {
    return _client.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
    });
  }
}
