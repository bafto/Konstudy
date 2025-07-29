import 'package:konstudy/models/black_board/black_board_entry.dart';
import 'package:konstudy/services/black_board/iblack_board_service.dart';

import '../auth/iauth_service.dart';
import '../persistence/iblack_board_entries_repository.dart';

class BlackBoardService implements IBlackBoardService {
  final IBlackBoardEntriesRepository _repository;
  final IAuthService _authService;

  BlackBoardService(this._repository, this._authService);

  @override
  Future<List<BlackBoardEntry>> fetchEntries() async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      throw Exception('Kein eingeloggter Benutzer');
    }
    return _repository.fetchEntriesForUser(userId);
  }

  @override
  Future<BlackBoardEntry> createEntry(
      String title,
      String description,
      String groupId,
      List<String> hashTags,
      ) async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      throw Exception('Kein eingeloggter Benutzer gefunden');
    }

    final entry = BlackBoardEntry(
      id: '', // leer, wird von DB gesetzt
      creatorId: userId,
      title: title,
      description: description,
      groupId: groupId,
      hashTags: hashTags,
    );

    return _repository.createEntry(entry);
  }

  @override
  Future<BlackBoardEntry> getEntryById({required String id}) {
    return _repository.getEntryById(id);
  }
}

