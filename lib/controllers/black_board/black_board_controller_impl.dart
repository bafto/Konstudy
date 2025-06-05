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
  Future<void> createEntry({
    required String name,
    required String description,
  }) async {
    if (name.isEmpty || description.isEmpty) {
      return Future.error("Name und Beschreibung dürfen nicht leer sein");
    }

    try {
      await _service.createEntry(name, description).catchError((e) {
        debugPrint(e.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
      return;
    }

    notifyListeners();
    return;
  }
}
