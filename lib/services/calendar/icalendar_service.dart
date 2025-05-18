import 'package:konstudy/models/calendar/calendar_event.dart';

abstract class ICalendarService {
  Future<List<CalendarEvent>> fetchEvents();

  Future<void> saveEvent(CalendarEvent event);

  Future<void> deleteEvent(int eventId);

  Future<void> updateEvent(CalendarEvent event);
}
