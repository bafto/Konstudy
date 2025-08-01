import 'package:flutter/foundation.dart';
import 'package:konstudy/controllers/black_board/iblack_board_controller.dart';
import 'package:konstudy/models/black_board/black_board_entry.dart';
import 'package:konstudy/services/black_board/iblack_board_service.dart';

class BlackBoardControllerImpl extends ChangeNotifier
    implements IBlackBoardController {
  final IBlackBoardService _service;

  BlackBoardControllerImpl(this._service);

  @override
  Future<List<BlackBoardEntry>> getEntries() => _service.fetchEntries();

  @override
  Future<BlackBoardEntry> createEntry({
    required String name,
    required String description,
    required String groupId,
    required List<String> hashTags,
  }) async {
    if (name.isEmpty || description.isEmpty) {
      return Future.error("Name und Beschreibung dürfen nicht leer sein");
    }

    try {
      return await _service.createEntry(name, description, groupId, hashTags);
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<BlackBoardEntry> getEntryById({required String id}) {
    try {
      return _service.getEntryById(id: id);
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future<List<BlackBoardEntry>> getEntriesByHashTag({
    required String hashTag,
  }) async {
    try {
      final entries = await getEntries();
      return entries
          .where(
            (e) =>
                e.hashTags.contains(hashTag) ||
                e.hashTags.any((e) => e.startsWith(hashTag)),
          )
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }
}
