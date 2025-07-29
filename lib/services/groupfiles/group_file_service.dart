import 'dart:io';

import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:konstudy/models/groupfiles/media.dart';
import 'package:konstudy/services/groupfiles/igroup_file_service.dart';

import '../persistence/igroup_file_repository.dart';

class GroupFileService implements IGroupFileService {
  final IGroupFileRepository _repository;
  final String subfolder;

  GroupFileService({
    required IGroupFileRepository repository,
    this.subfolder = 'media',
  }) : _repository = repository;

  @override
  Future<void> deleteFile(String filePath) {
    return _repository.deleteFile(filePath);
  }

  @override
  Future<Uint8List?> downloadFile(String filePath) {
    return _repository.downloadFile(filePath);
  }

  @override
  Future<List<Media>> listFiles(String groupId) async {
    final directory = '$groupId/$subfolder';
    final fileNames = await _repository.listFileNames(directory);

    return fileNames
        .map((name) => Media(
      fileName: name,
      filePath: '$directory/$name',
    ))
        .toList();
  }

  @override
  Future<void> uploadFile(String groupId, File file) async {
    final fileName = file.uri.pathSegments.last;
    final filePath = '$groupId/$subfolder/$fileName';
    final bytes = await file.readAsBytes();

    await _repository.uploadFile(path: filePath, bytes: bytes);
  }
}
