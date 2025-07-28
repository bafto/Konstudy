import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/models/calendar/repeat_type.dart';
import 'package:konstudy/routes/app_routes.dart';

class EventDetailsPage extends ConsumerWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  String _getRepeatText(CalendarEvent event) {
    switch (event.repeat) {
      case RepeatType.daily:
        return 'Täglich';
      case RepeatType.weekly:
        return 'Wöchentlich';
      case RepeatType.monthly:
        return 'Monatlich';
      case RepeatType.yearly:
        return 'Jährlich';
      case RepeatType.none:
        return 'Wiederholt sich nicht';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myevent = ref.watch(calendarControllerProvider).getEventById(eventId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        actions: [
          // Dropdown-Menü in der AppBar
          FutureBuilder(
            future: myevent,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return PopupMenuButton<String>(
                onSelected: (value) {
                  // Aktionen basierend auf der Auswahl durchführen
                  if (value == 'Bearbeiten') {
                    // Logik zum Bearbeiten des Events
                    EditEventPageRoute(
                      eventId: snapshot.data!.id,
                    ).push<void>(context);
                  } else if (value == 'Löschen') {
                    // Event löschen
                    _deleteEvent(context, ref, snapshot.data!);

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
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: myevent,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
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
                            snapshot.data!.title,
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
                          'Start: ${DateFormat.yMMMMd().add_Hm().format(snapshot.data!.start)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (snapshot.data?.end != null)
                      Row(
                        children: [
                          const Icon(Icons.event, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Ende: ${DateFormat.yMMMMd().add_Hm().format(snapshot.data!.end)}',
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
                          _getRepeatText(snapshot.data!),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Beschreibung:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
                        snapshot.data!.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Methode zum Löschen des Events
  void _deleteEvent(
    BuildContext context,
    WidgetRef ref,
    CalendarEvent myevent,
  ) {
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

                // Event löschen
                await controller.deleteEvent(myevent.id);

                // Optional: Zurück zur vorherigen Seite navigieren, wenn Event gelöscht wurde
                if (context.mounted) {
                  context.pop(); // geht zurück zur Kalenderübersicht
                }
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
