import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/routes/routes_paths.dart';

class EventDetailsPage extends ConsumerWidget {
  final CalendarEventData event;

  const EventDetailsPage({super.key, required this.event});

  String _getRepeatText(CalendarEventData event) {
    final recurrence = event.recurrenceSettings;
    if (recurrence == null ||
        recurrence.frequency == RepeatFrequency.doNotRepeat) {
      return 'Keine Wiederholung';
    }

    switch (recurrence.frequency) {
      case RepeatFrequency.daily:
        return 'Täglich';
      case RepeatFrequency.weekly:
        return 'Wöchentlich';
      case RepeatFrequency.monthly:
        return 'Monatlich';
      case RepeatFrequency.yearly:
        return 'Jährlich';
      default:
        return 'Wiederholt sich';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CalendarEvent myevent = event.event as CalendarEvent;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        actions: [
          // Dropdown-Menü in der AppBar
          PopupMenuButton<String>(
            onSelected: (value) {
              // Aktionen basierend auf der Auswahl durchführen
              if (value == 'Bearbeiten') {
                // Logik zum Bearbeiten des Events
                context.push(
                  RoutesPaths.editEvent,
                  extra: event,
                );
              } else if (value == 'Löschen') {
                // Event löschen
                _deleteEvent(context, ref);

                //fenster muss nach Löschen sich selber schließen
              }
            },
            itemBuilder: (BuildContext context) {
              return ['Bearbeiten', 'Löschen'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.title, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.title ?? 'Kein Titel',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Start: ${DateFormat.yMMMMd().add_Hm().format(event.startTime!)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (event.endTime != null)
                  Row(
                    children: [
                      const Icon(Icons.event, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Ende: ${DateFormat.yMMMMd().add_Hm().format(event.endTime!)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.repeat, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      _getRepeatText(event),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Beschreibung:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(minHeight: 80),
                  child: Text(
                    myevent.description ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Methode zum Löschen des Events
  void _deleteEvent(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Event löschen?'),
          content: const Text('Möchtest du dieses Event wirklich löschen?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dialog schließen

                // Hole den CalendarController aus dem Riverpod-Provider
                final controller = ref.read(calendarControllerProvider);

                CalendarEvent myevent = event.event as CalendarEvent;

                // Event löschen
                await controller.deleteEvent(myevent.id);

                // Optional: Zurück zur vorherigen Seite navigieren, wenn Event gelöscht wurde
                context.pop();
              },
              child: const Text('Ja'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
              },
              child: const Text('Nein'),
            ),
          ],
        );
      },
    );
  }
}
