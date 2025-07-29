import 'package:konstudy/models/editor/note.dart';
import 'package:konstudy/services/editor/inote_service.dart';

import '../persistence/igroup_notes_repository.dart';

class NoteService implements INoteService {
  final IGroupNotesRepository _noteRepository;

  NoteService(this._noteRepository);

  @override
  Future<List<Note>> fetchNotes(String groupId) {
    return _noteRepository.getNotesForGroup(groupId);
  }

  @override
  Future<Note> fetchNoteById(String id) {
    return _noteRepository.getNoteById(id);
  }

  @override
  Future<void> addNote(Note note) {
    return _noteRepository.createNote(note);
  }

  @override
  Future<void> updateNote(Note note) {
    return _noteRepository.updateNote(note);
  }

  @override
  Future<void> deleteNote(String id) {
    return _noteRepository.deleteNote(id);
  }
}

