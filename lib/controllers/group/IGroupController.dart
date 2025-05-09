import 'package:konstudy/models/group/Median.dart';
import 'package:konstudy/models/group/Note.dart';

abstract class IGroupController{
  List<Note> get notes;
  List<Median> get medians;
  Future<void> loadNotes();
  Future<void> loadMedians();
}