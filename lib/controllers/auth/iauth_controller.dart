import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IAuthController extends StateNotifier<AsyncValue<User?>> {
  IAuthController(super.state);

  Future<void> login(String email, String password);
  Future<void> signUp(String email, String password, String name);
  Future<void> logout();
  User? get currentUser;
}
