import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../igroup_file_repository.dart';

class SupabaseGroupFileRepository implements IGroupFileRepository {
  final SupabaseClient _client;
  final String bucket;

  SupabaseGroupFileRepository({
    required this.bucket,
    required SupabaseClient client,
  }) : _client = client;

  @override
  Future<void> deleteFile(String path) async {
    await _client.storage.from(bucket).remove([path]);
  }

  @override
  Future<Uint8List?> downloadFile(String path) async {
    return await _client.storage.from(bucket).download(path);
  }

  @override
  Future<void> uploadFile({
    required String path,
    required Uint8List bytes,
  }) async {
    await _client.storage
        .from(bucket)
        .uploadBinary(path, bytes, fileOptions: const FileOptions(upsert: true));
  }

  @override
  Future<List<String>> listFileNames(String directory) async {
    final files = await _client.storage.from(bucket).list(path: directory);
    return files.map((f) => f.name).toList();
  }
}
