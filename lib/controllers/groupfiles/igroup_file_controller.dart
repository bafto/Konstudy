import 'dart:io';

import 'package:konstudy/models/groupfiles/media.dart';

abstract class IGroupFileController {
  Future<List<Media>> listFiles(String groupId);
  Future<void> uploadFile(String groupId, File file);
  Future<void> deleteFile(String filePath);
  Future<void> downloadFile(String filePath);
}
