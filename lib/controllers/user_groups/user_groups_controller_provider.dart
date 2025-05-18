import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/user_groups/iuser_groups_controller.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_impl.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';
import 'package:konstudy/services/user_groups/user_groups_service.dart';

final userGroupsServiceProvider = Provider<IUserGroupsService>((ref) {
  return UserGroupsService(); //echte Implementierung
});

final userGroupsControllerProvider = Provider<IUserGroupsController>((ref) {
  final service = ref.read(userGroupsServiceProvider);
  return UserGroupsControllerImpl(service);
});
