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
  Future<List<CalendarEvent>> getEvents({String? groupId}) async {
    _events = await _service.fetchEvents(groupId);
    return _events;
  }

  @override
  Future<void> addEvent(CalendarEvent event, {String? groupId}) async {
    await _service.saveEvent(event, groupId);
    notifyListeners();
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _service.deleteEvent(eventId);
    notifyListeners();
  }

  @override
  Future<void> updateEvent(CalendarEvent event) async {
    await _service.updateEvent(event);
    notifyListeners();
  }

  @override
  Future<CalendarEvent> getEventById(String eventId) async {
    if (_events.isEmpty) {
      await _service.fetchEvent(eventId);
    }
    return _events.firstWhere((event) => event.id == eventId);
  }
}
