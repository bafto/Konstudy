import 'package:konstudy/controllers/group/igroup_controller.dart';
import 'package:konstudy/models/group/media.dart';
import 'package:konstudy/models/group/note.dart';
import 'package:konstudy/services/group/igroup_service.dart';

class GroupControllerImpl implements IGroupController {
  final IGroupService _service;

  GroupControllerImpl(this._service);

  @override
  Future<List<Note>> getNotes() async => _service.fetchNotes();

  @override
  Future<List<Media>> getMedia() async => _service.fetchMedia();
}
