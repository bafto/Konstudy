import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';
import 'package:konstudy/models/calendar/CalendarEvent.dart';
import 'package:konstudy/models/calendar/RepeatType.dart';

class AddEventPage extends ConsumerStatefulWidget {
  const AddEventPage({super.key});

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

  RepeatType _selectedRepeat = RepeatType.NONE;

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

                  // neues Event bauen
                  final newEvent = CalendarEvent(
                    id: 0,
                    title: _titleController.text,
                    start: _startDateTime!,
                    end: _endDateTime!,
                    repeat: _selectedRepeat,
                    description: _descriptionController.text,
                  );

                  await eventController.addEvent(newEvent);
                  context.pop();
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
      case RepeatType.NONE:
        return 'Keine Wiederholung';
      case RepeatType.DAILY:
        return 'Täglich';
      case RepeatType.WEEKLY:
        return 'Wöchentlich';
      case RepeatType.MONTHLY:
        return 'Monatlich';
      case RepeatType.YEARLY:
        return 'Jährlich';
    }
  }
}
