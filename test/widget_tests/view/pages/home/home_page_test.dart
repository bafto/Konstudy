import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konstudy/view/pages/home/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  Widget createMockedHomePage() {
    return ProviderScope(
      child: MaterialApp(
        home: HomePage(
          pageBuilders: [
                (context) => const Text('Mock Calendar'),
                (context) => const Text('Mock Groupoverview'),
                (context) => const Text('Mock Blackboard'),
          ],
        ),
      ),
    );
  }

  testWidgets('Startet mit Gruppenübersicht (Mock)', (WidgetTester tester) async {
    await tester.pumpWidget(createMockedHomePage());

    // Teste nur den Inhalt der Seite
    expect(find.text('Mock Groupoverview'), findsOneWidget);

    // Teste explizit den AppBar-Titel
    final appBar = find.byType(AppBar);
    expect(
      find.descendant(of: appBar, matching: find.text('Gruppen')),
      findsOneWidget,
    );
  });


  testWidgets('Wechselt zu Kalenderseite (Mock)', (WidgetTester tester) async {
    await tester.pumpWidget(createMockedHomePage());

    await tester.tap(find.byIcon(Icons.today));
    await tester.pumpAndSettle();

    final appBar = find.byType(AppBar);
    expect(
      find.descendant(of: appBar, matching: find.text('Mein Kalender')),
      findsOneWidget,
    );

    expect(find.text('Mock Calendar'), findsOneWidget);
  });


  testWidgets('Wechselt zu Schwarzes Brett Seite (Mock)', (WidgetTester tester) async {
    await tester.pumpWidget(createMockedHomePage());

    await tester.tap(find.byIcon(Icons.sticky_note_2_rounded));
    await tester.pumpAndSettle();

    final appBar = find.byType(AppBar);
    expect(
      find.descendant(of: appBar, matching: find.text('Schwarzes Brett')),
      findsOneWidget,
    );

    expect(find.text('Mock Blackboard'), findsOneWidget);
  });

}