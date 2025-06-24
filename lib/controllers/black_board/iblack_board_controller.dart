import 'package:flutter/foundation.dart';
import 'package:konstudy/models/black_board/black_board_entry.dart';

abstract class IBlackBoardController extends ChangeNotifier {
  Future<List<BlackBoardEntry>> getEntries();
  Future<BlackBoardEntry> createEntry({
    required String name,
    required String description,
    required String groupId,
  });
  Future<BlackBoardEntry> getEntryById({required String id});
}
