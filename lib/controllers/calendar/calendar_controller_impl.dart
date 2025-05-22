import 'package:flutter/cupertino.dart';
import 'package:konstudy/controllers/calendar/icalendar_controller.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/services/calendar/icalendar_service.dart';

class CalendarControllerImpl extends ChangeNotifier
    implements ICalendarController {
  final ICalendarService _service;

  CalendarControllerImpl(this._service);

  List<CalendarEvent> _events = [];

  @override
  Future<List<CalendarEvent>> getEvents() async {
    _events = await _service.fetchEvents();
    return _events;
  }

  @override
  Future<void> addEvent(CalendarEvent event) async {
    await _service.saveEvent(event);
    notifyListeners();
  }

  @override
  Future<void> deleteEvent(int eventId) async {
    await _service.deleteEvent(eventId);
    notifyListeners();
  }

  @override
  Future<void> updateEvent(CalendarEvent event) async {
    await _service.updateEvent(event);
    notifyListeners();
  }

  @override
  Future<CalendarEvent> getEventById(int eventId) async {
    if (_events.isEmpty) {
      await getEvents();
    }
    return _events.firstWhere((event) => event.id == eventId);
  }
}
