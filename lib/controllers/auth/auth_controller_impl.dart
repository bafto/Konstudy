import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/controllers/auth/iauth_controller.dart';
import 'package:konstudy/services/auth/iauth_service.dart';
import 'package:konstudy/routes/routes_paths.dart';

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

  @override
  Future<void> handleVerificationCallBackAndRedirect(BuildContext context) async {
    state = const AsyncValue.loading();
    final uri = Uri.base;

    try {
      // Tausche Code gegen Session
      await _authService.exchangeSession(uri);

      // Hole aktuellen User
      final user = _authService.getCurrentUser();

      // Aktualisiere State mit dem User
      state = AsyncValue.data(user);

      // Nach erfolgreichem Login weiterleiten
      if (context.mounted) {
        context.go(RoutesPaths.home);
      }
    } catch (e, st) {
      // Fehler setzen
      state = AsyncValue.error(e, st);
      rethrow; // Optional weiterwerfen, falls du das willst
    }
  }
}
