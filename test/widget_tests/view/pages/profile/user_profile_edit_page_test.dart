import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:konstudy/controllers/profile/user/user_profil_controller.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/provider/user_profil_provider.dart';
import 'package:konstudy/view/pages/profile/user_profile_edit_page.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../mocks/mock_user_profil_service.mocks.dart';



void main() {
  late MockIUserProfilService mockUserProfilService;
  late UserProfilController userProfilController;

  final testUser = UserProfil(
    id: '123',
    name: 'Max Mustermann',
    email: 'max@beispiel.de',
    isCurrentUser: true,
    profileImageUrl: null,
    description: 'Ich bin ein Testnutzer',
  );

  setUp(() {
    mockUserProfilService = MockIUserProfilService();
    userProfilController = UserProfilController(mockUserProfilService);

    // Mocks
    when(mockUserProfilService.fetchUserProfile(userId: anyNamed('userId')))
        .thenAnswer((_) async => testUser);

    when(mockUserProfilService.updateUserProfil(
        userId: anyNamed('userId'),
        name: anyNamed('name'),
        description: anyNamed('description')))
        .thenAnswer((_) async => Future.value());
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        userProfilControllerProvider.overrideWithValue(userProfilController),
      ],
      child: const MaterialApp(
        home: UserProfilEditPage(),
      ),
    );
  }

  testWidgets('Lädt und zeigt Profil korrekt an', (tester) async {
    await tester.pumpWidget(createTestWidget());

    // Ladeindikator wird gezeigt
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Warten bis Future fertig ist
    await tester.pumpAndSettle();

    expect(find.text('Max Mustermann'), findsOneWidget);
    expect(find.text('Ich bin ein Testnutzer'), findsOneWidget);

    // Textfelder sind mit den initialen Werten gefüllt
    final nameField = find.byWidgetPredicate(
          (widget) => widget is TextFormField && widget.controller!.text == 'Max Mustermann',
    );
    final descField = find.byWidgetPredicate(
          (widget) => widget is TextFormField && widget.controller!.text == 'Ich bin ein Testnutzer',
    );
    expect(nameField, findsOneWidget);
    expect(descField, findsOneWidget);
  });

  testWidgets('Speichert geänderte Profildaten', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Name ändern
    await tester.enterText(find.byType(TextFormField).first, 'Neuer Name');
    // Beschreibung ändern
    await tester.enterText(find.byType(TextFormField).last, 'Neue Beschreibung');

    // Speichern Button klicken
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    // Verifizieren, dass updateUserProfil mit den neuen Werten aufgerufen wurde
    verify(userProfilController.updateUserProfil(
      userId: testUser.id,
      name: 'Neuer Name',
      description: 'Neue Beschreibung',
    )).called(1);
  });

  testWidgets('Zeigt SnackBar bei Fehler beim Speichern', (tester) async {
    // updateUserProfil wirft Fehler
    when(mockUserProfilService.updateUserProfil(
        userId: anyNamed('userId'),
        name: anyNamed('name'),
        description: anyNamed('description')))
        .thenThrow(Exception('Speicher Fehler'));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Text ändern
    await tester.enterText(find.byType(TextFormField).first, 'Name');
    await tester.enterText(find.byType(TextFormField).last, 'Beschreibung');

    // Speichern
    await tester.tap(find.text('Speichern'));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Fehler: Exception: Speicher Fehler'), findsOneWidget);
  });
}
