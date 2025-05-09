import 'package:konstudy/models/calendar/CalendarEvent.dart';
import 'package:konstudy/services/calendar/ICalendarService.dart';

class CalendarService implements ICalendarService{
  @override
  Future<List<CalendarEvent>> fetchEvents() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      CalendarEvent(
        title: 'Meeting mit Max',
        start: DateTime.now().add(Duration(hours: 1)),
        end: DateTime.now().add(Duration(hours: 2)),
      ),
    ];
  }
}