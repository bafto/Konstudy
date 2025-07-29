import 'package:flutter_test/flutter_test.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/models/calendar/repeat_type.dart';
import 'package:konstudy/provider/calendar_provider.dart';
import 'package:konstudy/view/pages/calendar/calendar_page.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../mocks/mock_calendar_service.mocks.dart';

void main() {
  late MockICalendarService mockCalendarService;

  setUp(() {
    mockCalendarService = MockICalendarService();
  });

  Widget buildTestableWidget(Widget child) {
    return ProviderScope(
      overrides: [
        calendarServiceProvider.overrideWithValue(mockCalendarService),
      ],
      child: MaterialApp(home: child),
    );
  }


  testWidgets('zeigt Fehlertext wenn Service Fehler wirft', (tester) async {
    when(mockCalendarService.fetchEvents(any))
        .thenThrow(Exception('Fehler beim Laden'));

    await tester.pumpWidget(buildTestableWidget(const CalendarPage(groupId: 'g1')));

    await tester.pumpAndSettle();

    expect(find.text('Es gab einen Fehler beim Laden des Kalenders'), findsOneWidget);
  });

  testWidgets('zeigt Kalender-Events nach Laden', (tester) async {
    final now = DateTime(2025, 7, 29); // fixer Wert, vermeidet Timing-Issues

    final eventsFromService = [
      CalendarEvent(
        id: '1',
        title: 'Event 1',
        start: now,
        end: now.add(const Duration(hours: 1)),
        repeat: RepeatType.none,
        description: 'Beschreibung 1',
        eventColor: Colors.red,
        ownerId: 'owner1',
        groupId: 'g1',
      ),
      CalendarEvent(
        id: '2',
        title: 'Event 2',
        start: now.add(const Duration(days: 1)), // 30.07.2025
        end: now.add(const Duration(days: 1, hours: 2)),
        repeat: RepeatType.none, // ⬅️ erstmal kein Repeat, um Logik zu vereinfachen
        description: 'Beschreibung 2',
        eventColor: Colors.blue,
        ownerId: 'owner2',
        groupId: 'g1',
      ),
    ];

    when(mockCalendarService.fetchEvents(any))
        .thenAnswer((_) async => eventsFromService);

    await tester.pumpWidget(buildTestableWidget(const CalendarPage(groupId: 'g1')));
    await tester.pumpAndSettle();

    // Wechsel zur Wochenansicht, wo beide Events auftauchen
    await tester.tap(find.text('Woche'));
    await tester.pumpAndSettle();

    expect(find.text('Event 1'), findsWidgets);
    expect(find.text('Event 2'), findsWidgets);
  });
}