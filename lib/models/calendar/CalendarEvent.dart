import 'package:konstudy/models/calendar/RepeatType.dart';

class CalendarEvent {
  final int id;
  final String title;
  final DateTime start;
  final DateTime end;
  final RepeatType repeat;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.repeat = RepeatType.NONE,
  });

  // Optional: Für JSON-Speicherung
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as int,
      title: json['title'] as String,
      start: DateTime.parse(json['start'].toString()),
      end: DateTime.parse(json['end'].toString()),
      repeat: RepeatType.values.firstWhere(
            (e) => e.toString() == 'RepeatType.${json['repeat']}',
        orElse: () => RepeatType.NONE,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'repeat': repeat.name,
    };
  }
}
