import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/profile/group/group_profil_controller.dart';
import 'package:konstudy/controllers/profile/group/igroup_profil_controller.dart';
import 'package:konstudy/services/profile/group/group_profil_service.dart';
import 'package:konstudy/services/profile/group/igroup_profil_service.dart';

import 'app_provider.dart';
import 'auth_provider.dart';

final groupProfilServiceProvider = Provider<IGroupProfilService>((ref) {
  final groupRepo = ref.watch(groupRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  return GroupProfilService(groupRepo, authService);
});

final groupProfilControllerProvider = Provider<IGroupProfilController>((ref) {
  final service = ref.read(groupProfilServiceProvider);
  return GroupProfilController(service);
});
