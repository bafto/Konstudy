import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/user_groups/iuser_groups_controller.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_impl.dart';
import 'package:konstudy/provider/app_provider.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';
import 'package:konstudy/services/user_groups/user_groups_service.dart';

import 'auth_provider.dart';

final userGroupsServiceProvider = Provider<IUserGroupsService>((ref) {
  final userRepo = ref.watch(usersRepositoryProvider);
  final groupRepo = ref.watch(groupRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  return UserGroupsService(userRepo, groupRepo, authService); //echte Implementierung
});

final userGroupsControllerProvider =
    ChangeNotifierProvider.autoDispose<IUserGroupsController>((ref) {
      final service = ref.read(userGroupsServiceProvider);
      final controller = UserGroupsControllerImpl(service);
      return controller;
    });
