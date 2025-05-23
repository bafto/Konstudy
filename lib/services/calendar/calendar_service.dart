import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/services/calendar/icalendar_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class CalendarService implements ICalendarService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<CalendarEvent>> fetchEvents(String? groupId) async {
    final userId = _client.auth.currentUser!.id;
    final query = _client.from('calendar_events').select();

    if (groupId != null) {
      final membersResponse = await _client
          .from('group_members')
          .select('user_id')
          .eq('group_id', groupId);

      final memberIds = (membersResponse as List)
          .map((e) => e['user_id'] as String)
          .toList();

      final memberIdsFilter = memberIds.map((id) => "'$id'").join(',');

      query.or(
        'group_id.eq.$groupId,'
            'and(group_id.is.null,owner_id.in.($memberIdsFilter))',
      );
    } else {
      final groupsResponse = await _client
          .from('group_members')
          .select('group_id')
          .eq('user_id', userId);

      final groupIds = (groupsResponse as List)
          .map((e) => e['group_id'] as String)
          .toList();

      final groupIdsFilter = groupIds.map((id) => "'$id'").join(',');

      query.or(
        'owner_id.eq.$userId,'
            'group_id.in.($groupIdsFilter)',
      );
    }

    final response = await query;

    final events = (response as List)
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


  @override
  Future<CalendarEvent> fetchEvent(String eventId) async{
    final response = await _client
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
    final insertData = groupId != null
        ? event.toJson(userId: userId, groupId: groupId)
        : event.toJson(userId: userId);

    final response = await _client
        .from('calendar_events')
        .insert(insertData);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    final response = await _client
        .from('calendar_events')
        .delete()
        .eq('id', eventId);
  }

  @override
  Future<void> updateEvent(CalendarEvent newEvent) async {
    final response = await _client
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
