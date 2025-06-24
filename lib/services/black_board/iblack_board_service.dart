import 'package:konstudy/models/black_board/black_board_entry.dart';

abstract class IBlackBoardService {
  Future<List<BlackBoardEntry>> fetchEntries();
  Future<BlackBoardEntry> createEntry(
    String name,
    String description,
    String groupId,
  );
  Future<BlackBoardEntry> getEntryById({required String id});
}
