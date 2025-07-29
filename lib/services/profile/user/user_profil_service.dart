import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/services/profile/user/iuser_profil_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class UserProfilService implements IUserProfilService {
  final supabase = Supabase.instance.client;

  @override
  Future<UserProfil> fetchUserProfile({String? userId}) async {
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw Exception("Nicht Eingeloggt");
    }

    final effectiveUserId = userId ?? currentUserId;

    final response =
        await supabase
            .from('users')
            .select()
            .eq('id', effectiveUserId)
            .single();

    return UserProfil(
      id: response['id'] as String,
      name: response['name'] as String,
      email: response['email'] as String,
      description: response['description'] as String?,
      profileImageUrl: response['avatar_url'] as String?,
      isCurrentUser: effectiveUserId == currentUserId,
    );
  }

  @override
  Future<bool> deleteOwnAccount() async {
    // 1. Hole den aktuellen JWT (Access Token)
    final jwt = supabase.auth.currentSession?.accessToken ?? '';

    // 2. Endpoint der Edge Function aufrufen
    final response = await http.post(
      Uri.parse(
        'https://vdwxhiuzrltxosgufkdu.supabase.co/functions/v1/delete_user',
      ),
      headers: {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      },
    );

    // 3. Ergebnis prüfen
    if (response.statusCode == 200) {
      await supabase.auth.signOut();
      return true;
    } else {
      throw Exception('Fehler: ${response.body}');
    }
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

    await supabase
        .from('users')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();
  }
}
