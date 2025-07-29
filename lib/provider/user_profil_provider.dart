import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/profile/user/iuser_profil_controller.dart';
import 'package:konstudy/controllers/profile/user/user_profil_controller.dart';
import 'package:konstudy/services/profile/user/iuser_profil_service.dart';
import 'package:konstudy/services/profile/user/user_profil_service.dart';

import 'app_provider.dart';
import 'auth_provider.dart';

final userProfilServiceProvider = Provider<IUserProfilService>((ref) {
  final repo = ref.read(usersRepositoryProvider);
  final auth = ref.read(authServiceProvider);
  return UserProfilService(repo, auth);
});

final userProfilControllerProvider = Provider<IUserProfilController>((ref) {
  final service = ref.read(userProfilServiceProvider);
  return UserProfilController(service);
});
