import 'dart:io';

import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:konstudy/models/groupfiles/media.dart';
import 'package:konstudy/services/groupfiles/igroup_file_service.dart';

class GroupFileService implements IGroupFileService {
  final SupabaseClient _client = Supabase.instance.client;
  final String bucket = 'groupfiles';
  final String subfolder = 'media';

  @override
  Future<void> deleteFile(String filePath) async {
    await _client.storage.from(bucket).remove([filePath]);
  }

  @override
  Future<Uint8List?> downloadFile(String filePath) async {
    return await _client.storage.from(bucket).download(filePath);
  }

  @override
  Future<List<Media>> listFiles(String groupId) async {
    final response = await _client.storage
        .from(bucket)
        .list(path: '$groupId/$subfolder');

    if (response.isEmpty) return [];

    return response
        .map(
          (item) => Media(
            fileName: item.name,
            filePath: '$groupId/$subfolder/${item.name}',
          ),
        )
        .toList();
  }

  @override
  Future<void> uploadFile(String groupId, File file) async {
    final fileName = file.uri.pathSegments.last;
    final filePath = '$groupId/$subfolder/$fileName';

    final bytes = await file.readAsBytes();

    await _client.storage
        .from(bucket)
        .uploadBinary(
          filePath,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );
  }
}
