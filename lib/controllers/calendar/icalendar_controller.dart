import 'package:flutter/foundation.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';

abstract class ICalendarController extends ChangeNotifier {
  Future<List<CalendarEvent>> getEvents();
  Future<void> addEvent(CalendarEvent event);
  Future<void> deleteEvent(int eventId);
  Future<void> updateEvent(CalendarEvent event);
  Future<CalendarEvent> getEventById(int eventId);
}
