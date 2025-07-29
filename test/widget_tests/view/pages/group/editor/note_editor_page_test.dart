import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/models/editor/note.dart';
import 'package:konstudy/provider/note_provider.dart';
import 'package:konstudy/view/pages/group/editor/note_editor_page.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';

import '../../../../../mocks/mock_note_service.mocks.dart';

void main() {
  group('NoteEditorPage', () {
    late MockINoteService mockService;

    setUp(() {
      mockService = MockINoteService();
    });

    Widget buildTestableWidget(Widget child) {
      return ProviderScope(
        overrides: [
          noteServiceProvider.overrideWithValue(mockService),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('de'),
          ],
          home: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => child),
          ),
        ),
      );
    }


    testWidgets('zeigt leeres Editor-Formular bei neuer Notiz', (tester) async {
      when(mockService.fetchNoteById(any)).thenThrow(Exception('Not found'));

      await tester.pumpWidget(
        buildTestableWidget(const NoteEditorPage(groupId: 'g1')),
      );

      // Erster Frame: initState läuft, Ladeindikator wird gezeigt
      await tester.pump(); // Ein Frame bauen lassen

      // Ladeprozess abschließen: pumpAndSettle, um Future zu vollenden und UI neu zu bauen
      await tester.pumpAndSettle();

      // Nun ist der Ladeindikator weg und das Formular sichtbar
      expect(find.text('Neue Notiz'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });


    testWidgets('lädt bestehende Notiz vom Service', (tester) async {
      final note = Note(
        id: 'note1',
        groupId: 'g1',
        title: 'Test Titel',
        content: jsonEncode([
          {"insert": "Testinhalt\n"}
        ]),
      );

      when(mockService.fetchNoteById('note1')).thenAnswer((_) async => note);

      await tester.pumpWidget(
        buildTestableWidget(
          const NoteEditorPage(groupId: 'g1', noteId: 'note1'),
        ),
      );

      // Ladeindikator zeigen
      await tester.pump();


      // Warten bis geladen
      await tester.pumpAndSettle();

      expect(find.text('Notiz bearbeiten'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Test Titel'), findsOneWidget);
    });

  });
}
