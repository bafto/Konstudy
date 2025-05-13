import 'package:konstudy/models/calendar/CalendarEvent.dart';
import 'package:flutter/material.dart';

abstract class ICalendarController extends ChangeNotifier{
  List<CalendarEvent> get events;
  bool get isLoading;
  Future<void> loadEvents();
  Future<void> addEvent(CalendarEvent event);
  Future<void> deleteEvent(int eventId);
}