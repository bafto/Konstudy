import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/services/profile/user/iuser_profil_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
}
