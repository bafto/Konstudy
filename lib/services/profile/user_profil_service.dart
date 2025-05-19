import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/services/profile/iuser_profil_service.dart';

class UserProfilService implements IUserProfilService{
  final supabase = Supabase.instance.client;

  @override
  Future<UserProfil> fetchUserProfile() async{
    final userId = supabase.auth.currentUser?.id;
    if(userId == null){
      throw Exception("Nicht Eingeloggt");
    }

    final response = await supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    return UserProfil(
      name: response['name'] as String,
      email: response['email'] as String,
      description: response['description'] as String?,
      profileImageUrl: response['avatar_url'] as String?,
    );
  }
}