import 'package:konstudy/models/black_board/black_board_entry.dart';
import 'package:konstudy/services/black_board/iblack_board_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlackBoardService implements IBlackBoardService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<BlackBoardEntry>> fetchEntries() async {
    final entries = await _client.from('black_board_entries').select('*');
    return List<BlackBoardEntry>.from(
      (entries as List).map(
        (e) => BlackBoardEntry.fromJson(e as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> createEntry(String title, String description) async {
    final userId = _client.auth.currentUser!.id;

    return _client.from('black_board_entries').insert({
      'creatorId': userId,
      'title': title,
      'description': description,
    });
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
