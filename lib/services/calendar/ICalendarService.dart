import 'package:konstudy/models/calendar/CalendarEvent.dart';

abstract class ICalendarService{
  Future<List<CalendarEvent>> fetchEvents();

  Future<void> saveEvent(CalendarEvent event);

  Future<void> deleteEvent(int eventId);
}