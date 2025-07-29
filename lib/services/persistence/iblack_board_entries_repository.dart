import '../../models/black_board/black_board_entry.dart';

abstract class IBlackBoardEntriesRepository{
  Future<List<BlackBoardEntry>> fetchEntriesForUser(String userId);
  Future<BlackBoardEntry> createEntry(BlackBoardEntry entry);
  Future<BlackBoardEntry> getEntryById(String id);
}