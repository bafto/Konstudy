import 'package:konstudy/models/black_board/black_board_entry.dart';
import 'package:konstudy/services/black_board/iblack_board_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlackBoardService implements IBlackBoardService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<BlackBoardEntry>> fetchEntries() async {
    final groupIds = (await _client
        .from('group_members')
        .select()
        .eq(
          'user_id',
          _client.auth.currentUser!.id,
        )).map((e) => e['group_id'] as String);

    final entriesResponse = await _client
        .from('black_board_entries')
        .select('*')
        .neq('creatorId', _client.auth.currentUser!.id);

    final entries = List<BlackBoardEntry>.from(
      (entriesResponse as List).map(
        (e) => BlackBoardEntry.fromJson(e as Map<String, dynamic>),
      ),
    );

    // return entries;
    return entries.where((e) => !groupIds.contains(e.groupId)).toList();
  }

  @override
  Future<BlackBoardEntry> createEntry(
    String title,
    String description,
    String groupId,
  ) async {
    final userId = _client.auth.currentUser!.id;

    return BlackBoardEntry.fromJson(
      await _client
          .from('black_board_entries')
          .insert({
            'creatorId': userId,
            'title': title,
            'description': description,
            'groupId': groupId,
          })
          .select()
          .single(),
    );
  }

  @override
  Future<BlackBoardEntry> getEntryById({required String id}) async {
    final result =
        await _client
            .from('black_board_entries')
            .select('*')
            .eq('id', id)
            .single();
    return BlackBoardEntry.fromJson(result);
  }
}
