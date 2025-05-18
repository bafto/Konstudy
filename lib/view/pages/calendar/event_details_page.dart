import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/models/calendar/repeat_type.dart';
import 'package:konstudy/routes/app_routes.dart';

class EventDetailsPage extends ConsumerWidget {
  final CalendarEvent event;

  const EventDetailsPage({super.key, required this.event});

  String _getRepeatText(CalendarEvent event) {
    switch (event.repeat) {
      case RepeatType.DAILY:
        return 'Täglich';
      case RepeatType.WEEKLY:
        return 'Wöchentlich';
      case RepeatType.MONTHLY:
        return 'Monatlich';
      case RepeatType.YEARLY:
        return 'Jährlich';
      case RepeatType.NONE:
        return 'Einmalig';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                EditEventPageRoute(eventId: event.id).push<void>(context);
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
                        event.title,
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
                      'Start: ${DateFormat.yMMMMd().add_Hm().format(event.start)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Ende: ${DateFormat.yMMMMd().add_Hm().format(event.end)}',
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
                    event.description,
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
    showDialog<void>(
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

                // Event löschen
                await controller.deleteEvent(event.id);

                // Optional: Zurück zur vorherigen Seite navigieren, wenn Event gelöscht wurde
                Navigator.pop(context);
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
