import 'package:konstudy/models/calendar/CalendarEvent.dart';

abstract class ICalendarService{
  Future<List<CalendarEvent>> fetchEvents();
}