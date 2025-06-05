import 'dart:io';

import 'package:konstudy/controllers/groupfiles/igroup_file_controller.dart';
import 'package:konstudy/models/groupfiles/media.dart';
import 'package:konstudy/services/groupfiles/igroup_file_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class GroupControllerImpl implements IGroupFileController {
  final IGroupFileService _service;

  GroupControllerImpl(this._service);

  @override
  Future<List<Media>> listFiles(String groupId) async => _service.listFiles(groupId);

  @override
  Future<void> deleteFile(String filePath) async => _service.deleteFile(filePath);

  @override
  Future<void> downloadFile(String filePath, String fileName) async{
    final bytes = await _service.downloadFile(filePath);

    if(bytes != null){
      final dirctory = await getApplicationDocumentsDirectory();
      final file = File('${dirctory.path}/$fileName');

      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }else{
      throw Exception('Fehler beim Herunterladen der Datei');
    }
  }

  @override
  Future<void> uploadFile(String groupId, File file) async => _service.uploadFile(groupId, file);

}
