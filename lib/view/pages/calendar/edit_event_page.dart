import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/models/calendar/repeat_type.dart';

class EditEventPage extends ConsumerStatefulWidget {
  final CalendarEventData event;

  const EditEventPage({super.key, required this.event});

  @override
  ConsumerState<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends ConsumerState<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _startController;
  late TextEditingController _endController;

  late CalendarEvent _myevent;
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  late RepeatType _selectedRepeat;

  @override
  void initState() {
    super.initState();
    _myevent = widget.event.event as CalendarEvent;

    _titleController = TextEditingController(text: _myevent.title);
    _descriptionController = TextEditingController(
      text: _myevent.description ?? '',
    );
    _startDateTime = _myevent.start;
    _endDateTime = _myevent.end;
    _selectedRepeat = _myevent.repeat ?? RepeatType.NONE;

    _startController = TextEditingController(
      text: _formatDateTime(_startDateTime!),
    );
    _endController = TextEditingController(
      text: _formatDateTime(_endDateTime!),
    );
  }

  String _formatDateTime(DateTime dt) {
    final date = DateFormat.yMd().format(dt);
    final time = DateFormat.Hm().format(dt);
    return '$date $time';
  }

  Future<void> _pickDateTime({
    required TextEditingController controller,
    required DateTime? initialDateTime,
    required ValueChanged<DateTime> onConfirmed,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
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
    controller.text = _formatDateTime(combined);
  }

  @override
  Widget build(BuildContext context) {
    final eventController = ref.read(calendarControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Event bearbeiten")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titel'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Titel erforderlich' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Startzeit'),
                onTap:
                    () => _pickDateTime(
                      controller: _startController,
                      initialDateTime: _startDateTime,
                      onConfirmed: (dt) => _startDateTime = dt,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Endzeit'),
                onTap:
                    () => _pickDateTime(
                      controller: _endController,
                      initialDateTime: _endDateTime,
                      onConfirmed: (dt) => _endDateTime = dt,
                    ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RepeatType>(
                value: _selectedRepeat,
                items:
                    RepeatType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_repeatTypeLabel(type)),
                      );
                    }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedRepeat = val;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Wiederholung'),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Beschreibung'),
                maxLines: 3,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final updated = _myevent.copyWith(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    start: _startDateTime!,
                    end: _endDateTime!,
                    repeat: _selectedRepeat,
                  );

                  await eventController.updateEvent(updated);
                  context.pop();
                },
                child: const Text('Änderungen speichern'),
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
