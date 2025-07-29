import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/editor/note.dart';
import '../igroup_notes_repository.dart';

class SupabaseGroupNotesRepository implements IGroupNotesRepository {
  final SupabaseClient _client;

  SupabaseGroupNotesRepository(this._client);

  @override
  Future<List<Note>> getNotesForGroup(String groupId) async {
    final res = await _client
        .from('group_notes')
        .select()
        .eq('group_id', groupId);

    return (res as List)
        .map((e) => Note.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Note> getNoteById(String id) async {
    final res = await _client
        .from('group_notes')
        .select()
        .eq('id', id)
        .single();

    return Note.fromMap(res);
  }

  @override
  Future<void> createNote(Note note) async {
    await _client.from('group_notes').insert(note.toMap());
  }

  @override
  Future<void> updateNote(Note note) async {
    await _client.from('group_notes').update(note.toMap()).eq('id', note.id);
  }

  @override
  Future<void> deleteNote(String id) async {
    await _client.from('group_notes').delete().eq('id', id);
  }
}
