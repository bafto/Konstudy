import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_impl.dart';
import 'package:konstudy/controllers/calendar/icalendar_controller.dart';
import 'package:konstudy/services/calendar/calendar_service.dart';
import 'package:konstudy/services/calendar/icalendar_service.dart';

final calendarServiceProvider = Provider<ICalendarService>((ref) {
  return CalendarService(); //echte Implementierung
});

final calendarControllerProvider =
    ChangeNotifierProvider.autoDispose<ICalendarController>((ref) {
      final service = ref.read(calendarServiceProvider);
      final controller = CalendarControllerImpl(service);
      return controller;
    });
