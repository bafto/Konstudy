import 'package:konstudy/models/calendar/calendar_event.dart';

abstract class ICalendarService {
  Future<List<CalendarEvent>> fetchEvents(String? groupId);

  Future<CalendarEvent> fetchEvent(String eventId);

  Future<void> saveEvent(CalendarEvent event, String? groupId);

  Future<void> deleteEvent(String eventId);

  Future<void> updateEvent(CalendarEvent event);
}
