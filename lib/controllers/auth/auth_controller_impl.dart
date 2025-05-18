import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:konstudy/controllers/auth/IAuthController.dart';
import 'package:konstudy/services/auth/IAuthService.dart';

class AuthControllerImpl extends StateNotifier<AsyncValue<User?>>
    implements IAuthController {
  final IAuthService _authService;

  AuthControllerImpl(this._authService) : super(const AsyncValue.data(null));

  @override
  User? get currentUser => _authService.getCurrentUser();

  @override
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final res = await _authService.signIn(email, password);
      state = AsyncValue.data(res.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  Future<void> signUp(String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      final res = await _authService.signUp(email, password, name);
      state = AsyncValue.data(res.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  Future<void> logout() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }
}
