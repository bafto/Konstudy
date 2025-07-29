import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/profile/user_profil.dart';
import '../iusers_repository.dart';
import 'package:http/http.dart' as http;


class SupabaseUsersRepository implements IUserRepository {
  final SupabaseClient _client;

  SupabaseUsersRepository(this._client);

  @override
  Future<List<UserProfil>> searchUsers(String query) async {
    final data = await _client
        .from('users')
        .select('id, name, email')
        .ilike('name', '%$query%')
        .limit(10);

    return data.map(UserProfil.fromJson).toList();
  }
  @override
  Future<UserProfil> fetchUserProfil(String userId) async {
    final response =
    await _client.from('users').select().eq('id', userId).single();

    return UserProfil(
      id: response['id'] as String,
      name: response['name'] as String,
      email: response['email'] as String,
      description: response['description'] as String?,
      profileImageUrl: response['avatar_url'] as String?,
      isCurrentUser: false, // Kann der Service setzen oder anders regeln
    );
  }

  @override
  Future<void> updateUserProfil({
    required String userId,
    String? name,
    String? description,
    String? profileImageUrl,
  }) async {
    final updates = <String, dynamic>{
      'id': userId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (profileImageUrl != null) 'avatar_url': profileImageUrl,
    };

    await _client.from('users').update(updates).eq('id', userId).select().single();
  }

  @override
  Future<bool> deleteOwnAccount(String jwtToken) async {
    final response = await http.post(
      Uri.parse('https://your-project.supabase.co/functions/v1/delete_user'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}
