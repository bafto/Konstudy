import 'package:konstudy/models/group/editor/note.dart';
import 'package:konstudy/services/editor/inote_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteService implements INoteService{
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Note>> fetchNotes(String groupId) async{
    final res = await _client
        .from('group_notes')
        .select()
        .eq('group_id', groupId);

    return (res as List).map((e) => Note.fromMap(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Note> fetchNoteById(String id) async{
    final response = await _client
        .from('group_notes')
        .select().eq('id', id)
        .single();

    return Note.fromMap(response);
  }

  @override
  Future<void> addNote(Note note) async{
    await _client.from('group_notes').insert(note.toMap());
  }

  @override
  Future<void> updateNote(Note note) async{
    await _client.from('group_notes').update(note.toMap()).eq('id', note.id);
  }

  @override
  Future<void> deleteNote(String id) async{
    await _client.from('group_notes').delete().eq('id', id);
  }
}