import 'dart:io';

import 'package:konstudy/controllers/groupfiles/igroup_file_controller.dart';
import 'package:konstudy/models/groupfiles/media.dart';
import 'package:konstudy/services/groupfiles/igroup_file_service.dart';

class GroupControllerImpl implements IGroupFileController {
  final IGroupFileService _service;

  GroupControllerImpl(this._service);

  @override
  Future<List<Media>> listFiles(String groupId) async => _service.listFiles(groupId);

  @override
  Future<void> deleteFile(String filePath) async => _service.deleteFile(filePath);

  @override
  Future<void> downloadFile(String filePath) async => _service.downloadFile(filePath);

  @override
  Future<void> uploadFile(String groupId, File file) async => _service.uploadFile(groupId, file);

}
