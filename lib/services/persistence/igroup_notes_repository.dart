import '../../models/editor/note.dart';

abstract class IGroupNotesRepository{
  Future<List<Note>> getNotesForGroup(String groupId);
  Future<Note> getNoteById(String id);
  Future<void> createNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
}