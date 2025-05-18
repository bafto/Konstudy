import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/group/group_controller_impl.dart';
import 'package:konstudy/controllers/group/igroup_controller.dart';
import 'package:konstudy/services/group/group_service.dart';
import 'package:konstudy/services/group/igroup_service.dart';

final groupServiceProvider = Provider<IGroupService>((ref) {
  return GroupService(); //echte Implementierung
});

final groupControllerProvider = Provider<IGroupController>((ref) {
  final service = ref.read(groupServiceProvider);
  return GroupControllerImpl(service);
});
