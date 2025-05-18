import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/services/auth/auth_service_impl.dart';
import 'package:konstudy/services/auth/iauth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'iauth_controller.dart';

import 'auth_controller_impl.dart';

final authServiceProvider = Provider<IAuthService>((ref) {
  return AuthService();
});

final authControllerProvider =
    StateNotifierProvider<IAuthController, AsyncValue<User?>>((ref) {
      final authService = ref.read(authServiceProvider);
      return AuthControllerImpl(authService);
    });
