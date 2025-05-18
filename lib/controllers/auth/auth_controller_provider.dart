import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/services/auth/AuthServiceImpl.dart';
import 'package:konstudy/services/auth/IAuthService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'IAuthController.dart';

import 'AuthControllerImpl.dart';

final authServiceProvider = Provider<IAuthService>((ref) {
  return AuthService();
});

final authControllerProvider =
    StateNotifierProvider<IAuthController, AsyncValue<User?>>((ref) {
      final authService = ref.read(authServiceProvider);
      return AuthControllerImpl(authService);
    });
