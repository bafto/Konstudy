import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/black_board/black_board_controller_impl.dart';
import 'package:konstudy/controllers/black_board/iblack_board_controller.dart';
import 'package:konstudy/models/black_board/black_board_entry.dart';
import 'package:konstudy/services/black_board/black_board_service.dart';
import 'package:konstudy/services/black_board/iblack_board_service.dart';

import 'app_provider.dart';
import 'auth_provider.dart';

final blackBoardServiceProvider = Provider<IBlackBoardService>((ref) {
  final repo = ref.watch(blackBoardRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  return BlackBoardService(repo, authService); //echte Implementierung
});

final blackBoardControllerProvider =
    ChangeNotifierProvider.autoDispose<IBlackBoardController>((ref) {
      final service = ref.read(blackBoardServiceProvider);
      final controller = BlackBoardControllerImpl(service);
      return controller;
    });

final blackBoardEntryProvider = FutureProvider.family<BlackBoardEntry, String>((
  ref,
  entryId,
) {
  final controller = ref.watch(blackBoardControllerProvider);
  return controller.getEntryById(id: entryId);
});
