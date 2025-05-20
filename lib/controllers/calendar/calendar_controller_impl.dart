import 'package:flutter/cupertino.dart';
import 'package:konstudy/controllers/calendar/icalendar_controller.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/services/calendar/icalendar_service.dart';

class CalendarControllerImpl extends ChangeNotifier
    implements ICalendarController {
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
    notifyListeners();
    try {
      final fetched = await _service.fetchEvents();
      _events.clear();
      _events.addAll(fetched);
    } catch (e) {
      // Fehlerbehandlung falls Fetch fehlschlägt
      debugPrint("Fehler beim Laden der Events: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Benachrichtige die UI, dass der Ladeprozess abgeschlossen ist.
    }
  }

  @override
  Future<void> addEvent(CalendarEvent event) async {
    await _service.saveEvent(event);
    notifyListeners();
  }

  @override
  Future<void> deleteEvent(int eventId) async {
    await _service.deleteEvent(eventId);
    notifyListeners();
  }

  @override
  Future<void> updateEvent(CalendarEvent event) async {
    await _service.updateEvent(event);
    notifyListeners();
  }

  @override
  Future<CalendarEvent> getEventById(int eventId) async {
    return _events.firstWhere((event) => event.id == eventId);
  }
}
