import 'dart:ui';

import 'package:konstudy/services/calendar/ICalendarService.dart';
import 'package:konstudy/controllers/calendar/ICalendarController.dart';
import 'package:konstudy/models/calendar/CalendarEvent.dart';



class CalendarControllerImpl implements ICalendarController {
  final ICalendarService _service;

  CalendarControllerImpl(this._service);

  final List<CalendarEvent> _events = [];
  bool _isLoading = false;

  @override
  List<CalendarEvent> get events => _events;

  @override
  bool get isLoading => _isLoading;

  @override
  Future<void> loadEvents() async {
    _isLoading = true;
    final fetched = await _service.fetchEvents();
    _events.clear();
    _events.addAll(fetched);
    _isLoading = false;
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}