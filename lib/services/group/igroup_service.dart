import 'package:konstudy/models/group/media.dart';
import 'package:konstudy/models/group/note.dart';

abstract class IGroupService {
  Future<List<Note>> fetchNotes();
  Future<List<Media>> fetchMedia();
}
