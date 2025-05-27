import 'dart:io';
import 'dart:typed_data';
import 'package:konstudy/models/groupfiles/media.dart';

abstract class IGroupFileService {
  Future<List<Media>> listFiles(String groupId);
  Future<void> uploadFile(String groupId, File file);
  Future<void> deleteFile(String filePath);
  Future<Uint8List?> downloadFile(String filePath);
}
