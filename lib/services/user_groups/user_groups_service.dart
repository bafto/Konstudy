import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserGroupsService implements IUserGroupsService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Group>> fetchGroups() async {
    await Future.delayed(
      Duration(seconds: 1),
    ); //simulation eines Netzwerkaufruf
    return [
      Group(
        id: 1,
        name: "Embedded Systems",
        description: "Embedded Systems",
        memberNames: ["Hendrik", "Leon"],
      ),
      Group(
        id: 1,
        name: "Mobile Anwendungen",
        description: "Mobile Anwendungen",
        memberNames: ["Hendrik", "Konstantin"],
      ),
    ];
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
