import 'package:konstudy/models/black_board/black_board_entry.dart';

abstract class IBlackBoardService {
  Future<List<BlackBoardEntry>> fetchEntries();
  Future<BlackBoardEntry> createEntry(
    String name,
    String description,
    String groupId,
    List<String> hashTags,
  );
  Future<BlackBoardEntry> getEntryById({required String id});
}
