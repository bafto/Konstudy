import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/group/GroupControllerImpl.dart';
import 'package:konstudy/controllers/group/IGroupController.dart';
import 'package:konstudy/services/group/GroupService.dart';
import 'package:konstudy/services/group/IGroupService.dart';

final groupServiceProvider = Provider<IGroupService>((ref) {
  return GroupService(); //echte Implementierung
});

final groupControllerProvider = Provider<IGroupController>((ref) {
  final service = ref.read(groupServiceProvider);
  return GroupControllerImpl(service);
});
