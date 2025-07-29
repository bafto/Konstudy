import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/black_board/black_board_entry.dart';
import '../iblack_board_entries_repository.dart';

class SupabaseBlackBoardEntriesRepository implements IBlackBoardEntriesRepository {
  final SupabaseClient _client;

  SupabaseBlackBoardEntriesRepository(this._client);

  @override
  Future<List<BlackBoardEntry>> fetchEntriesForUser(String userId) async {
    final groupIdsResponse = await _client
        .from('group_members')
        .select()
        .eq('user_id', userId);

    final groupIds = (groupIdsResponse as List)
        .map((e) => e['group_id'] as String)
        .toSet();

    final entriesResponse = await _client
        .from('black_board_entries')
        .select('*')
        .neq('creatorId', userId);

    final entries = (entriesResponse as List)
        .map((e) => BlackBoardEntry.fromJson(e as Map<String, dynamic>))
        .toList();

    // Filter out entries where the entry's groupId is in user's groupIds
    return entries.where((entry) => !groupIds.contains(entry.groupId)).toList();
  }

  @override
  Future<BlackBoardEntry> createEntry(BlackBoardEntry entry) async {
    final inserted = await _client
        .from('black_board_entries')
        .insert({
      'creatorId': entry.creatorId,
      'title': entry.title,
      'description': entry.description,
      'groupId': entry.groupId,
      'hashTags': entry.hashTags,
    })
        .select()
        .single();

    return BlackBoardEntry.fromJson(inserted);
  }

  @override
  Future<BlackBoardEntry> getEntryById(String id) async {
    final result = await _client
        .from('black_board_entries')
        .select('*')
        .eq('id', id)
        .single();

    return BlackBoardEntry.fromJson(result);
  }
}
