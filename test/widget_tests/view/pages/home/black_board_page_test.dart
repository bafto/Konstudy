import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/black_board/black_board_controller_impl.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_impl.dart';
import 'package:konstudy/models/black_board/black_board_entry.dart';
import 'package:konstudy/provider/black_board_provider.dart';
import 'package:konstudy/provider/user_groups_provider.dart';
import 'package:konstudy/view/pages/home/black_board_page.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/mock_user_groups_service.mocks.dart';
import '../../../../mocks/mock_black_board_service.mocks.dart';

void main() {
  late MockIBlackBoardService mockBlackBoardService;
  late MockIUserGroupsService mockUserGroupsService;
  late UserGroupsControllerImpl mockUserGroupsController;

  setUp(() {
    mockBlackBoardService = MockIBlackBoardService();
    mockUserGroupsService = MockIUserGroupsService();

    // Setup BlackBoardService Mocks
    when(mockBlackBoardService.fetchEntries()).thenAnswer(
          (_) async => [
        BlackBoardEntry(id: '1',  description: 'desc1', groupId: 'g1', hashTags: ['tag1'], creatorId: '', title: 'Test Entry 1'),
        BlackBoardEntry(id: '2',  description: 'desc2', groupId: 'g2', hashTags: ['tag2'], creatorId: '', title: 'Test Entry 2'),
      ],
    );

    // UserGroupsController mit mockUserGroupsService
    mockUserGroupsController = UserGroupsControllerImpl(mockUserGroupsService);

    // UserGroupsService Mocks, falls benötigt (optional)
    // Beispiel: wenn UserGroupsController Methoden aufruft, die getestet werden sollen

  });

  testWidgets('BlackBoardPage zeigt Einträge an', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          blackBoardServiceProvider.overrideWithValue(mockBlackBoardService),
          blackBoardControllerProvider.overrideWith(
                (ref) => BlackBoardControllerImpl(mockBlackBoardService),
          ),

          // UserGroupsController Provider mit mockUserGroupsController überschreiben
          userGroupsControllerProvider.overrideWith(
                (ref) => mockUserGroupsController,
          ),
        ],
        child: const MaterialApp(
          home: BlackBoardPage(),
        ),
      ),
    );

    // Ladeindikator sichtbar am Anfang
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Auf das Laden der Future warten
    await tester.pumpAndSettle();

    // Prüfen, ob die Einträge angezeigt werden
    expect(find.text('Test Entry 1'), findsOneWidget);
    expect(find.text('Test Entry 2'), findsOneWidget);
  });
}