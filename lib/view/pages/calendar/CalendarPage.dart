import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(calendarControllerProvider);

    if (controller.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Events umwandeln für calendar_view
    final events = controller.events.map((e) {
      return CalendarEventData(
        title: e.title,
        date: e.start,
        startTime: e.start,
        endTime: e.end,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Kalender')),
      body: DayView(
        controller: EventController()..addAll(events),
      ),
    );
  }
}