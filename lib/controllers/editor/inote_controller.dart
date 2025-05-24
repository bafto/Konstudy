import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:konstudy/models/group/editor/note.dart';

abstract class INoteController extends ChangeNotifier{
  Future<Note> getNoteById(String id);
  Future<List<Note>> loadNotes(String groupId);
  Future<void> saveNotes({required String? id, required String groupId, required String title, required String contentJson, required bool isNew,});
  Future<void> deleteNote(String id);
}