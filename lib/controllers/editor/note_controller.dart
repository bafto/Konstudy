import 'package:konstudy/models/editor/note.dart';
import 'package:konstudy/services/editor/inote_service.dart';
import 'package:konstudy/controllers/editor/inote_controller.dart';
import 'package:flutter/foundation.dart';


class NoteController extends ChangeNotifier  implements INoteController {
  final INoteService _service;


  NoteController(this._service);

  @override
  Future<void> saveNotes({
    required String? id,
    required String groupId,
    required String title,
    required String contentJson,
    required bool isNew
  }) async {
    final note = Note(
        id: id ?? '',
        groupId: groupId,
        title: title.trim(),
        content: contentJson
    );

    if (isNew) {
      await _service.addNote(note);
    } else {
      await _service.updateNote(note);
    }
  }

  @override
  Future<List<Note>> loadNotes(String groupId) => _service.fetchNotes(groupId);

  @override
  Future<void> deleteNote(String id) async{
    await _service.deleteNote(id);
  }

  @override
  Future<Note> getNoteById(String id) async{
    return await _service.fetchNoteById(id);
  }


}