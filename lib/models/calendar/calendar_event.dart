import 'package:konstudy/models/calendar/repeat_type.dart';

class CalendarEvent {
  final int id;
  final String title;
  final DateTime start;
  final DateTime end;
  final RepeatType repeat;
  final String description;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.repeat = RepeatType.none,
    this.description = "",
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
        orElse: () => RepeatType.none,
      ),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'repeat': repeat.name,
      'description': description,
    };
  }

  CalendarEvent copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    RepeatType? repeat,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      repeat: repeat ?? this.repeat,
    );
  }
}
