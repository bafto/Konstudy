import 'package:konstudy/models/calendar/CalendarEvent.dart';
import 'package:konstudy/services/calendar/ICalendarService.dart';

class CalendarService implements ICalendarService{
  //In-Memory-Liste als Datenbank
  final List<CalendarEvent> _eventList = [
    CalendarEvent(
      id: 1,
      title: 'Meeting mit Max',
      start: DateTime.now().add(Duration(hours: 1)),
      end: DateTime.now().add(Duration(hours: 2)),
    ),
  ];

  @override
  Future<List<CalendarEvent>> fetchEvents() async {
    await Future.delayed(Duration(seconds: 1)); //Simuliert Netwerkaufruf
    return List.unmodifiable(_eventList);
  }

  @override
  Future<void> saveEvent(CalendarEvent event) async{
    await Future.delayed(Duration(seconds: 1));//Simuliert Netwerkaufruf

    // Neue ID berechnen (max ID + 1)
    final nextId = _eventList.isEmpty
        ? 1
        : _eventList.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    // Neues Event mit gesetzter ID
    final newEvent = CalendarEvent(
      id: nextId,
      title: event.title,
      start: event.start,
      end: event.end,
      repeat: event.repeat,
    );
    _eventList.add(newEvent);
    print("Event gespeichert: ${newEvent.title} & ${newEvent.repeat}");
  }

  @override
  Future<void> deleteEvent(int eventId) async{
    await Future.delayed(Duration(seconds: 1));//Simuliert Netwerkaufruf
    _eventList.removeWhere((event) => event.id == eventId);

  }
}