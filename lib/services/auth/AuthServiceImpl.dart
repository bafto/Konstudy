import 'package:konstudy/services/auth/IAuthService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends IAuthService{
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<AuthResponse> signUp(String email, String password, String name) async{
    final response = await _client.auth.signUp(password: password, email: email);
    if(response.user != null){
      await _client.from('users').insert({
        'id': response.user!.id,
        'name': name,
        'email': response.user!.email,
      });
    }
    return response;
  }

  @override
  Future<AuthResponse> signIn(String email, String password) {
    return _client.auth.signInWithPassword(password: password, email: email);
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  User? getCurrentUser() => _client.auth.currentUser;
}