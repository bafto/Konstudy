import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotrue/src/types/user.dart';
import 'package:konstudy/controllers/auth/iauth_controller.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_impl.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/provider/auth_provider.dart';
import 'package:konstudy/provider/user_groups_provider.dart';
import 'package:konstudy/view/pages/home/group_overview.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../mocks/fake_auth_controller.dart';
import '../../../../mocks/mock_user_groups_service.mocks.dart';

// --- Mock-Klassen ---


final testGroups = [
  Group(
    id: '1',
    name: 'Test Gruppe 1',
    description: 'Beschreibung 1',
    members: [],
  ),
  Group(
    id: '2',
    name: 'Test Gruppe 2',
    description: 'Beschreibung 2',
    members: [],
  ),
];

void main() {
  late MockIUserGroupsService mockService;

  setUp(() {
    mockService = MockIUserGroupsService();

    // Mock: getGroups liefert die Testgruppen zurück
    when(mockService.fetchGroups()).thenAnswer((_) async => testGroups);
  });

  testWidgets('Groupoverview zeigt Gruppen und FloatingActionButton', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userGroupsControllerProvider.overrideWith(
                (ref) => UserGroupsControllerImpl(mockService),
          ),
          authControllerProvider.overrideWith(
                (ref) => FakeAuthController(),
          ),
        ],
        child: const MaterialApp(
          home: Groupoverview(),
        ),
      ),
    );


    // Erstes Frame (FutureBuilder wartet)
    await tester.pump();

    // Zweites Frame nach Future abgeschlossen
    await tester.pumpAndSettle();

    // Prüfe, ob Gruppenname angezeigt wird
    expect(find.text('Test Gruppe 1'), findsOneWidget);
    expect(find.text('Test Gruppe 2'), findsOneWidget);

    // Prüfe FloatingActionButton ist da
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
