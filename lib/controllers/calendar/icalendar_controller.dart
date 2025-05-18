import 'package:flutter/material.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';

abstract class ICalendarController extends ChangeNotifier {
  List<CalendarEvent> get events;
  bool get isLoading;
  Future<void> loadEvents();
  Future<void> addEvent(CalendarEvent event);
  Future<void> deleteEvent(int eventId);
  Future<void> updateEvent(CalendarEvent event);
  Future<CalendarEvent> getEventById(int eventId);
}
