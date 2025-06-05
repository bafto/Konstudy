import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/black_board/black_board_controller_impl.dart';
import 'package:konstudy/controllers/black_board/iblack_board_controller.dart';
import 'package:konstudy/services/black_board/black_board_service.dart';
import 'package:konstudy/services/black_board/iblack_board_service.dart';

final blackBoardServiceProvider = Provider<IBlackBoardService>((ref) {
  return BlackBoardService(); //echte Implementierung
});

final blackBoardControllerProvider =
    ChangeNotifierProvider.autoDispose<IBlackBoardController>((ref) {
      final service = ref.read(blackBoardServiceProvider);
      final controller = BlackBoardControllerImpl(service);
      return controller;
    });
