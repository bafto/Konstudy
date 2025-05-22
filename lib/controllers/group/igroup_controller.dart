import 'package:konstudy/models/group/media.dart';
import 'package:konstudy/models/group/note.dart';

abstract class IGroupController {
  Future<List<Note>> getNotes();
  Future<List<Media>> getMedia();
}
