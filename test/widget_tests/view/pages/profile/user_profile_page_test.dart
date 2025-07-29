import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konstudy/controllers/auth/iauth_controller.dart';
import 'package:konstudy/controllers/profile/user/user_profil_controller.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/provider/auth_provider.dart';
import 'package:konstudy/provider/user_profil_provider.dart';
import 'package:konstudy/view/pages/profile/user_profile_page.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

import '../../../../mocks/mock_auth_controller.mocks.dart';
import '../../../../mocks/mock_user_profil_service.mocks.dart';



// Mockklasse mit Mockito

void main() {
  late MockIUserProfilService mockUserProfilService;
  late UserProfilController userProfilController;
  late MockIAuthController mockAuthController;

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
    mockAuthController = MockIAuthController();

    // Alle Stubs vor dem Test definieren
    when(mockUserProfilService.fetchUserProfile(userId: anyNamed('userId')))
        .thenAnswer((invocation) async {
      // Hier keine weiteren `when`-Aufrufe!
      return testUser;
    });

    when(mockUserProfilService.deleteOwnAccount())
        .thenAnswer((_) async => true);

    when(mockAuthController.logout()).thenAnswer((_) async => Future.value());
  });

  Widget createTestWidget({String? userId}) {
    return ProviderScope(
      overrides: [
        userProfilControllerProvider.overrideWithValue(userProfilController),
        authControllerProvider.overrideWith((ref) => mockAuthController),
      ],
      child: MaterialApp(
        home: UserProfilePage(userId: userId),
      ),
    );
  }

  testWidgets('zeigt UserProfil korrekt an', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Max Mustermann'), findsOneWidget);
    expect(find.text('max@beispiel.de'), findsOneWidget);
    expect(find.text('Ich bin ein Testnutzer'), findsOneWidget);
  });

  testWidgets('PopupMenu zeigt Bearbeiten, Ausloggen, Löschen für aktuellen Nutzer', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('Bearbeiten'), findsOneWidget);
    expect(find.text('Ausloggen'), findsOneWidget);
    expect(find.text('Löschen'), findsOneWidget);
  });

  testWidgets('Logout ruft authController.logout auf', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ausloggen'));
    await tester.pumpAndSettle();

    verify(mockAuthController.logout()).called(1);
  });


  testWidgets('Zeigt Lade-Indikator während das Profil geladen wird', (tester) async {
    final completer = Completer<UserProfil>();
    when(mockUserProfilService.fetchUserProfile(userId: anyNamed('userId')))
        .thenAnswer((_) => completer.future);

    await tester.pumpWidget(createTestWidget());

    // Zu diesem Zeitpunkt ist der Future noch nicht abgeschlossen
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Future abschließen
    completer.complete(testUser);
    await tester.pumpAndSettle();

    expect(find.text('Max Mustermann'), findsOneWidget);
  });

  testWidgets('Löscht den Account bei Bestätigung', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Löschen'));
    await tester.pumpAndSettle();

    expect(find.text('Account löschen?'), findsOneWidget);
    expect(find.text('Ja'), findsOneWidget);
    expect(find.text('Nein'), findsOneWidget);

    await tester.tap(find.text('Ja'));
    await tester.pumpAndSettle();

    verify(mockUserProfilService.deleteOwnAccount()).called(1);
  });

  testWidgets('Abbruch beim Account löschen funktioniert', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Löschen'));
    await tester.pumpAndSettle();

    expect(find.text('Account löschen?'), findsOneWidget);

    await tester.tap(find.text('Nein'));
    await tester.pumpAndSettle();

    verifyNever(mockUserProfilService.deleteOwnAccount());
  });

  testWidgets('Popup-Menü für andere Nutzer zeigt nur „Nachricht senden“ und „Profil melden“', (tester) async {
    final otherUser = UserProfil(
      id: '456',
      name: 'Anna Beispiel',
      email: 'anna@beispiel.de',
      isCurrentUser: false,
      profileImageUrl: null,
      description: 'Andere Userin',
    );

    when(mockUserProfilService.fetchUserProfile(userId: anyNamed('userId')))
        .thenAnswer((_) async => otherUser);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('Nachricht senden'), findsOneWidget);
    expect(find.text('Profil melden'), findsOneWidget);
    expect(find.text('Bearbeiten'), findsNothing);
    expect(find.text('Ausloggen'), findsNothing);
    expect(find.text('Löschen'), findsNothing);
  });
}