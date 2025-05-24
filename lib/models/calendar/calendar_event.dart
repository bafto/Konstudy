import 'package:konstudy/models/calendar/repeat_type.dart';
import 'package:flutter/material.dart';


class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final RepeatType repeat;
  final String description;
  final String? ownerId;
  final String? groupId;
  Color? eventColor;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.repeat = RepeatType.none,
    this.description = "",
    this.eventColor,
    this.ownerId,
    this.groupId,
  });

  // Optional: Für JSON-Speicherung
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      start: DateTime.parse(json['start_time'].toString()),
      end: DateTime.parse(json['end_time'].toString()),
      repeat: RepeatType.values.firstWhere(
        (e) => e.toString() == 'RepeatType.${json['recurrence']}',
        orElse: () => RepeatType.none,
      ),
      description: json['description'] as String,
      ownerId: json['owner_id'] as String?,
      groupId: json['group_id'] as String?
    );
  }

  Map<String, dynamic> toJson({String? userId, String? groupId}) {
    return {
      'title': title,
      'start_time': start.toIso8601String(),
      'end_time': end.toIso8601String(),
      'recurrence': repeat.name,
      'description': description,
      'owner_id': userId,
      'group_id': groupId,
    };
  }

  Map<String, dynamic> toUpdateJson() => {
    'title': title,
    'start_time': start.toIso8601String(),
    'end_time': end.toIso8601String(),
    'recurrence': repeat.name,
    'description': description,
  };

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    RepeatType? repeat,
    String? ownerId,
    String? groupId,
    Color? eventcolor,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      repeat: repeat ?? this.repeat,
      ownerId: ownerId ?? this.ownerId,
      groupId: groupId ?? this.groupId,
      eventColor: eventcolor ?? this.eventColor,
    );
  }
}
