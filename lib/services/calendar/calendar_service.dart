import 'package:flutter/material.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/services/calendar/icalendar_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarService implements ICalendarService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<CalendarEvent>> fetchEvents(String? groupId) async {
    final userId = _client.auth.currentUser!.id;

    debugPrint("here");
    final queryResult =
        groupId != null ? _loadGroupGroups(groupId) : _loadUserGroups(userId);
    final response = await queryResult;
    debugPrint("response: $response");

    final events =
        response
            .map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
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

  Future<List<dynamic>> _loadUserGroups(String userId) async {
    final groupsResponse = await _client
        .from('group_members')
        .select('group_id')
        .eq('user_id', userId);

    final groupIds =
        (groupsResponse as List).map((e) => e['group_id'] as String).toList();

    final groupIdsFilter = groupIds.join(',');

    final orClause =
        groupIds.isNotEmpty
            ? 'owner_id.eq.$userId,group_id.in.($groupIdsFilter)'
            : 'owner_id.eq.$userId';

    try {
      final result = await _client
          .from('calendar_events')
          .select()
          .or(orClause);

      return result as List;
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      return Future.error(e);
    }
  }

  Future<List<dynamic>> _loadGroupGroups(String groupId) async {
    final membersResponse = await _client
        .from('group_members')
        .select('user_id')
        .eq('group_id', groupId);

    final memberIds =
        (membersResponse as List).map((e) => e['user_id'] as String).toList();

    final memberIdsFilter = memberIds.join(',');

    try {
      final result = await _client
          .from('calendar_events')
          .select()
          .or(
            'group_id.eq.$groupId,'
            'and(group_id.is.null,owner_id.in.($memberIdsFilter))',
          );
      return result as List;
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      return Future.error(e);
    }
  }

  @override
  Future<CalendarEvent> fetchEvent(String eventId) async {
    final response =
        await _client
            .from('calendar_events')
            .select()
            .eq('id', eventId)
            .maybeSingle(); // gibt null zurück statt Exception bei 0 Treffern

    if (response == null) {
      throw Exception('Event mit ID $eventId nicht gefunden');
    }

    return CalendarEvent.fromJson(response);
  }

  @override
  Future<void> saveEvent(CalendarEvent event, String? groupId) async {
    final userId = _client.auth.currentUser!.id;
    final insertData =
        groupId != null
            ? event.toJson(userId: userId, groupId: groupId)
            : event.toJson(userId: userId);

    await _client.from('calendar_events').insert(insertData);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _client.from('calendar_events').delete().eq('id', eventId);
  }

  @override
  Future<void> updateEvent(CalendarEvent newEvent) async {
    await _client
        .from('calendar_events')
        .update(newEvent.toUpdateJson())
        .eq('id', newEvent.id);
  }

  Color _getEventColor({
    required String currentUserId,
    String? ownerId,
    String? groupId,
  }) {
    if (currentUserId == ownerId && groupId == null) {
      return Colors.blue;
    } else if (currentUserId == ownerId && groupId != null) {
      return Colors.green;
    } else if (currentUserId != ownerId && groupId != null) {
      return Colors.orange;
    } else {
      return Colors.purple;
    }
  }
}
