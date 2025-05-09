import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/services/calendar/CalendarService.dart';
import 'package:konstudy/services/calendar/ICalendarService.dart';
import 'package:konstudy/controllers/calendar/ICalendarController.dart';
import 'package:konstudy/controllers/calendar/CalendarControllerImpl.dart';


final calendarServiceProvider = Provider<ICalendarService>((ref) {
  return CalendarService(); //echte Implementierung
});

final calendarControllerProvider = ChangeNotifierProvider<ICalendarController>((ref) {
  final service = ref.read(calendarServiceProvider);
  final controller = CalendarControllerImpl(service);
  controller.loadEvents(); // automatisch beim Erstellen laden
  return controller;
});