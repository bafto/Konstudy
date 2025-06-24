import 'package:konstudy/models/black_board/black_board_entry.dart';
import 'package:konstudy/services/black_board/iblack_board_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlackBoardService implements IBlackBoardService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<BlackBoardEntry>> fetchEntries() async {
    final entries = await _client
        .from('black_board_entries')
        .select('*')
        .not('creatorId', 'eq', _client.auth.currentUser!.id);
    return List<BlackBoardEntry>.from(
      (entries as List).map(
        (e) => BlackBoardEntry.fromJson(e as Map<String, dynamic>),
      ),
    );
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
