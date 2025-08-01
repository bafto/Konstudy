import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/provider/calendar_provider.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/models/calendar/repeat_type.dart';

class AddEventPage extends ConsumerStatefulWidget {
  final String? groupId;
  const AddEventPage({super.key, this.groupId});

  @override
  ConsumerState<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  //Kombiniert schowDatePicker für Datum und dann schowTimePicker für die Uhrzeit
  Future<void> _pickDateTime({
    required TextEditingController controller,
    required DateTime? initialDateTime,
    required ValueChanged<DateTime> onConfirmed,
  }) async {
    // 1. Datum wählen
    final date = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date == null) return;

    // 2. Uhrzeit wählen
    final time = await showTimePicker(
      context: context,
      initialTime:
          initialDateTime != null
              ? TimeOfDay.fromDateTime(initialDateTime)
              : TimeOfDay.now(),
    );
    if (time == null) return;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    onConfirmed(combined);

    // Feld-Text formatieren
    controller.text =
        '${date.toLocal().toIso8601String().split('T')[0]} '
        '${time.format(context)}';
  }

  RepeatType _selectedRepeat = RepeatType.none;

  @override
  Widget build(BuildContext context) {
    final eventController = ref.watch(calendarControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Neues Event hinzufügen")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Titel
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (v) =>
                        v == null || v.isEmpty
                            ? 'Bitte einen Titel eingeben'
                            : null,
              ),
              const SizedBox(height: 16),

              // Start Datum + Uhrzeit
              TextFormField(
                controller: _startController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Start (Datum & Uhrzeit)',
                  border: OutlineInputBorder(),
                ),
                onTap:
                    () => _pickDateTime(
                      controller: _startController,
                      initialDateTime: _startDateTime,
                      onConfirmed: (dt) => _startDateTime = dt,
                    ),
                validator:
                    (v) => v == null || v.isEmpty ? 'Bitte Start wählen' : null,
              ),
              const SizedBox(height: 16),

              // End Datum + Uhrzeit
              TextFormField(
                controller: _endController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Ende (Datum & Uhrzeit)',
                  border: OutlineInputBorder(),
                ),
                onTap:
                    () => _pickDateTime(
                      controller: _endController,
                      initialDateTime: _endDateTime,
                      onConfirmed: (dt) => _endDateTime = dt,
                    ),
                validator:
                    (v) => v == null || v.isEmpty ? 'Bitte Ende wählen' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RepeatType>(
                value: _selectedRepeat,
                decoration: const InputDecoration(
                  labelText: 'Wiederholung',
                  border: OutlineInputBorder(),
                ),
                items:
                    RepeatType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_repeatTypeLabel(type)),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRepeat = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Speichern-Button
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (_startDateTime == null || _endDateTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bitte Start- und Endzeit angeben'),
                      ),
                    );
                    return;
                  }

                  if (_endDateTime!.isBefore(_startDateTime!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Endzeitpunkt darf nicht vor dem Startzeitpunkt liegen',
                        ),
                      ),
                    );
                    return;
                  }

                  final newEvent = CalendarEvent(
                    id: '0',
                    title: _titleController.text,
                    start: _startDateTime!,
                    end: _endDateTime!,
                    repeat: _selectedRepeat,
                    description: _descriptionController.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(child: CircularProgressIndicator()),
                    ),
                  );
                  await eventController
                      .addEvent(newEvent, groupId: widget.groupId)
                      .then((_) {
                        if (context.mounted) {
                          context.pop();
                        }
                      })
                      .catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Es gab einen Fehler beim erstellen des Events",
                            ),
                          ),
                        );
                      });
                },
                child: const Text('Event speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _repeatTypeLabel(RepeatType type) {
    switch (type) {
      case RepeatType.none:
        return 'Keine Wiederholung';
      case RepeatType.daily:
        return 'Täglich';
      case RepeatType.weekly:
        return 'Wöchentlich';
      case RepeatType.monthly:
        return 'Monatlich';
      case RepeatType.yearly:
        return 'Jährlich';
    }
  }
}
