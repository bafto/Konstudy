import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/models/editor/note.dart';
import 'package:konstudy/provider/note_provider.dart';
import 'package:konstudy/view/pages/group/editor/note_collection_page.dart';
import 'package:konstudy/view/widgets/cards/note_card.dart';
import 'package:mockito/mockito.dart';

import '../../../../../mocks/mock_note_service.mocks.dart';


void main() {
  testWidgets('Zeigt Notizen aus dem Service an', (WidgetTester tester) async {
    final mockService = MockINoteService();

    final fakeNotes = [
      Note(id: '1', groupId: 'g1', title: 'Note 1', content: 'Content 1'),
      Note(id: '2', groupId: 'g1', title: 'Note 2', content: 'Content 2'),
    ];

    // Stubbe fetchNotes
    when(mockService.fetchNotes('g1')).thenAnswer((_) async => fakeNotes);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          noteServiceProvider.overrideWithValue(mockService),
        ],
        child: const MaterialApp(
          home: NoteCollectionPage(groupId: 'g1'),
        ),
      ),
    );

    // Initial: CircularProgressIndicator wird angezeigt
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Warte, bis FutureBuilder abgeschlossen ist
    await tester.pumpAndSettle();

    // Erwartung: Beide Notizen werden angezeigt
    expect(find.text('Note 1'), findsOneWidget);
    expect(find.text('Note 2'), findsOneWidget);
    expect(find.byType(NoteCard), findsNWidgets(2));
  });

  testWidgets('Zeigt "Keine Notizen", wenn Liste leer ist', (WidgetTester tester) async {
    final mockService = MockINoteService();

    when(mockService.fetchNotes('g1')).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          noteServiceProvider.overrideWithValue(mockService),
        ],
        child: const MaterialApp(
          home: NoteCollectionPage(groupId: 'g1'),
        ),
      ),
    );

    await tester.pump(); // Erstes Frame
    await tester.pumpAndSettle(); // Warten auf FutureBuilder

    expect(find.text('Keine Notizen'), findsOneWidget);
  });
}