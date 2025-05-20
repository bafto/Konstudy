import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/profile/iuser_profil_controller.dart';
import 'package:konstudy/controllers/profile/user_profil_controller.dart';
import 'package:konstudy/services/profile/iuser_profil_service.dart';
import 'package:konstudy/services/profile/user_profil_service.dart';

final userProfilServiceProvider = Provider<IUserProfilService>((ref) {
  return UserProfilService();
});

final userProfilControllerProvider = Provider<IUserProfilController>((ref) {
  final service = ref.read(userProfilServiceProvider);
  return UserProfilController(service);
});
