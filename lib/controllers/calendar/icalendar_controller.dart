import 'package:flutter/foundation.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';

abstract class ICalendarController extends ChangeNotifier {
  Future<List<CalendarEvent>> getEvents({String? groupId});
  Future<void> addEvent(CalendarEvent event, {String? groupId});
  Future<void> deleteEvent(String eventId);
  Future<void> updateEvent(CalendarEvent event);
  Future<CalendarEvent> getEventById(String eventId);
}
