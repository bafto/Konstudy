import 'package:konstudy/services/auth/iauth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:konstudy/services/auth/iauth_service.dart';

class AuthService extends IAuthService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<AuthResponse> signUp(
    String email,
    String password,
    String name,
  ) async {
    final response = await _client.auth.signUp(
      password: password,
      email: email,
    );
    if (response.user != null) {
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
  Future<void> exchangeSession(Uri uri) async {
    await Supabase.instance.client.auth.exchangeCodeForSession(uri.toString());
  }

  @override
  User? getCurrentUser() => _client.auth.currentUser;
}
