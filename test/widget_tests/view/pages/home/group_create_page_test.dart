import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_impl.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/provider/user_groups_provider.dart';
import 'package:konstudy/view/pages/home/group_create_page.dart';
import 'package:mockito/mockito.dart';


import '../../../../mocks/mock_user_groups_service.mocks.dart';

void main() {
  late MockIUserGroupsService mockService;
  late UserGroupsControllerImpl controller;

  setUp(() {
    mockService = MockIUserGroupsService();
    controller = UserGroupsControllerImpl(mockService);
  });

  testWidgets('CreateGroupPage zeigt Nutzer-Suche und erstellt Gruppe', (tester) async {
    // Arrange: Mock-Verhalten festlegen
    when(mockService.searchUsers(any)).thenAnswer((_) async => [
      UserProfil(id: '1', name: 'Max Mustermann', email: 'max@example.com'),
      UserProfil(id: '2', name: 'Lisa Müller', email: 'lisa@example.com'),
    ]);
    when(mockService.createGroup(any, any, any)).thenAnswer(
          (_) async => Group(
        id: 'g1',
        name: 'Test Gruppe',
        description: 'Test Beschreibung',
        members: [],
      ),
    );

    // Widget aufbauen mit ProviderScope und Controller-Override
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userGroupsControllerProvider.overrideWith((ref) => controller),
          // Wenn du einen AuthController hast, hier ggf. mocken und override hinzufügen
        ],
        child: const MaterialApp(home: CreateGroupPage()),
      ),
    );

    // Act: Text in Suchfeld eingeben, um Nutzer zu suchen
    await tester.enterText(find.byType(TextField).at(2), 'Max'); // 3. TextField = Suche
    // Pump und warten, dass FutureBuilder fertig wird
    await tester.pumpAndSettle();

    // Assert: Gefundene Nutzer werden angezeigt
    expect(find.text('Max Mustermann'), findsOneWidget);
    expect(find.text('Lisa Müller'), findsOneWidget);

    // Act: Nutzer auswählen (erstes ListTile trailing Icon drücken)
    await tester.tap(find.byIcon(Icons.check_box_outline_blank).first);
    await tester.pump();

    // Act: Gruppennamen und Beschreibung ausfüllen
    await tester.enterText(find.byType(TextField).at(0), 'Test Gruppe'); // Name
    await tester.enterText(find.byType(TextField).at(1), 'Test Beschreibung'); // Beschreibung

    // Act: Button drücken, um Gruppe zu erstellen
    // Suche nach ElevatedButton mit Text "Gruppe erstellen"
    final buttonFinder = find.widgetWithText(ElevatedButton, 'Gruppe erstellen');
    await tester.tap(buttonFinder);
    await tester.pump(); // SnackBar mit CircularProgressIndicator erscheint

    // Warte bis Future abgeschlossen ist
    await tester.pumpAndSettle();

    // Assert: Erfolgsmeldung (SnackBar) erscheint
    expect(find.text('Gruppe wurde erstellt'), findsOneWidget);

    // Optional: Prüfen, ob createGroup mit richtigen Parametern aufgerufen wurde
    verify(mockService.createGroup(
      'Test Gruppe',
      'Test Beschreibung',
      any,
    )).called(1);
  });
}
