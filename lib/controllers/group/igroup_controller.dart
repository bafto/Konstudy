import 'package:konstudy/models/group/media.dart';
import 'package:konstudy/models/group/Note.dart';

abstract class IGroupController {
  List<Note> get notes;
  List<Media> get medians;
  Future<void> loadNotes();
  Future<void> loadMedians();
}
