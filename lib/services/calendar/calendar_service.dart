import 'package:flutter/material.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/services/calendar/icalendar_service.dart';
import 'package:konstudy/services/persistence/icalendar_events_repository.dart';

import '../auth/iauth_service.dart';

class CalendarService implements ICalendarService {
  final ICalendarEventsRepository _repository;
  final IAuthService _authService;

  CalendarService(this._repository, this._authService);

  @override
  Future<List<CalendarEvent>> fetchEvents(String? groupId) async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      throw Exception('Kein eingeloggter Benutzer gefunden');
    }

    final response = groupId != null
        ? await _repository.loadGroupEvents(groupId)
        : await _repository.loadUserEvents(userId);

    final events = response
        .map((e) => CalendarEvent.fromJson(e))
        .toList();

    for (var event in events) {
      event.eventColor = _getEventColor(
        currentUserId: userId,
        ownerId: event.ownerId,
        groupId: event.groupId,
      );
    }

    return events;
  }

  @override
  Future<CalendarEvent> fetchEvent(String eventId) async {
    final json = await _repository.getEventById(eventId);
    if (json == null) throw Exception('Event $eventId not found');
    return CalendarEvent.fromJson(json);
  }

  @override
  Future<void> saveEvent(CalendarEvent event, String? groupId) async {
    final userId = await _authService.getCurrentUserId();
    final data = groupId != null
        ? event.toJson(userId: userId, groupId: groupId)
        : event.toJson(userId: userId);
    await _repository.insertEvent(data);
  }

  @override
  Future<void> deleteEvent(String eventId) {
    return _repository.deleteEvent(eventId);
  }

  @override
  Future<void> updateEvent(CalendarEvent newEvent) {
    return _repository.updateEvent(newEvent.id, newEvent.toUpdateJson());
  }

  Color _getEventColor({
    required String currentUserId,
    String? ownerId,
    String? groupId,
  }) {
    if (currentUserId == ownerId && groupId == null) return Colors.blue;
    if (currentUserId == ownerId && groupId != null) return Colors.green;
    if (currentUserId != ownerId && groupId != null) return Colors.orange;
    return Colors.purple;
  }
}

