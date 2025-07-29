import 'dart:typed_data';

abstract class IGroupFileRepository {
  Future<void> uploadFile({
    required String path,
    required Uint8List bytes,
  });

  Future<Uint8List?> downloadFile(String path);

  Future<void> deleteFile(String path);

  Future<List<String>> listFileNames(String directory);
}