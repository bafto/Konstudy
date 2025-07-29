import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/editor/inote_controller.dart';
import 'package:konstudy/controllers/editor/note_controller.dart';
import 'package:konstudy/services/editor/inote_service.dart';
import 'package:konstudy/services/editor/note_service.dart';

import 'app_provider.dart';

final noteServiceProvider = Provider<INoteService>((ref) {
  final repo = ref.watch(noteRepositoryProvider);
  return NoteService(repo);
});

final noteControllerProvider =
    ChangeNotifierProvider.autoDispose<INoteController>((ref) {
      final service = ref.read(noteServiceProvider);
      return NoteController(service);
    });
