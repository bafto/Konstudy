import 'package:konstudy/models/black_board/black_board_entry.dart';

abstract class IBlackBoardService {
  Future<List<BlackBoardEntry>> fetchEntries();
  Future<void> createEntry(String name, String description);
  Future<BlackBoardEntry> getEntryById({required String id});
}
