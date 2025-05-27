import 'package:konstudy/models/group/editor/note.dart';

abstract class INoteService{
  Future<List<Note>> fetchNotes(String groupId);
  Future<Note> fetchNoteById(String id);
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
}