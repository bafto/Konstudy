import 'package:konstudy/models/group/Median.dart';
import 'package:konstudy/models/group/Note.dart';

abstract class IGroupService {
  Future<List<Note>> fetchNotes();
  Future<List<Median>> fetchMedian();
}
