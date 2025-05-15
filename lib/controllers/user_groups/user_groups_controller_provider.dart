import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/user_groups/IUserGroupsController.dart';
import 'package:konstudy/controllers/user_groups/UserGroupsControllerImpl.dart';
import 'package:konstudy/services/user_groups/IUserGroupsService.dart';
import 'package:konstudy/services/user_groups/UserGroupsService.dart';

final userGroupsServiceProvider = Provider<IUserGroupsService>((ref) {
  return UserGroupsService(); //echte Implementierung
});

final userGroupsControllerProvider = Provider<IUserGroupsController>((ref) {
  final service = ref.read(userGroupsServiceProvider);
  return UserGroupsControllerImpl(service);
});
