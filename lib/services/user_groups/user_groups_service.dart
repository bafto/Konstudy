import 'package:konstudy/models/user_groups/group.dart';
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
    final groupIds = (groupIdResult as List)
        .map((e) => e['group_id'] as String)
        .toList();

    if(groupIds.isEmpty){
      return [];
    }

    // 3. Hole die vollständigen Gruppen
    final groupData = await _client
        .from('groups')
        .select('*, group_members(*)')
        .inFilter('id', groupIds);

    // 4. Daten in Group umwandeln
    return List<Group>.from(
        (groupData as List).map((e) => Group.fromJson(e as Map<String, dynamic>))
    );
  }

  @override
  Future<void> createGroup(String name, String? description, List<String> gruppenmitglieder) async{
    final response = await _client.from('groups')
        .insert({
          'name': name,
          'description': description,
          'created_by': _client.auth.currentUser!.id,
        }).select();

    final insertedgroupId = response[0]['id'];

    await _client.from('group_members')
        .insert({
          'group_id': insertedgroupId,
          'user_id': _client.auth.currentUser!.id,
          'is_admin': true,
        });

    if(gruppenmitglieder.isNotEmpty){
      for(final id in gruppenmitglieder){
        await _client.from('group_members')
            .insert({
              'group_id': insertedgroupId,
              'user_id': id,
            });
      }
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchUsers(String query) async{
    if(query.isEmpty){
      return [];
    }

    try {
      final data = await _client
          .from('users')
          .select('id, name, email')
          .ilike('name', '%$query%')
          .limit(10);

      return List<Map<String, dynamic>>.from(data);
    } catch (error) {
      // Optional: Logging oder Error-Handling
      throw Exception('Fehler bei der Nutzersuche: $error');
    }
  }
}
