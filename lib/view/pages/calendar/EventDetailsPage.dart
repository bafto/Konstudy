import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';
import 'package:konstudy/models/calendar/CalendarEvent.dart';



class EventDetailsPage extends ConsumerWidget {
  final CalendarEventData event;

  const EventDetailsPage({super.key, required this.event});

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
                print("Edit Event");
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Titel: ${event.title}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("Start: ${event.startTime}"),
            Text("Ende: ${event.endTime}"),
            if (event.description != null) ...[
              const SizedBox(height: 10),
              Text("Beschreibung: ${event.description}"),
            ],
          ],
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