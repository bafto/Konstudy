import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthService{
  Future<AuthResponse> signUp(String email, String password, String name);

  Future<AuthResponse> signIn(String email, String password);

  Future<void> signOut();

  Future<void> exchangeSession(Uri uri);

  User? getCurrentUser();
}