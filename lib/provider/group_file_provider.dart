import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/groupfiles/group_file_controller_impl.dart';
import 'package:konstudy/controllers/groupfiles/igroup_file_controller.dart';
import 'package:konstudy/services/groupfiles/group_file_service.dart';
import 'package:konstudy/services/groupfiles/igroup_file_service.dart';

import 'app_provider.dart';

final groupFileServiceProvider = Provider<IGroupFileService>((ref) {
  final repository = ref.watch(groupFileRepositoryProvider);
  return GroupFileService(repository: repository); //echte Implementierung
});

final groupFileControllerProvider = Provider<IGroupFileController>((ref) {
  final service = ref.read(groupFileServiceProvider);
  return GroupControllerImpl(service);
});
