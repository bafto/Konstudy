import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/services/calendar/icalendar_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CalendarService implements ICalendarService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<CalendarEvent>> fetchEvents(String? groupId) async {
    final userId = _client.auth.currentUser!.id;
    final query = _client.from('calendar_events').select();

    if(groupId != null){
      query.eq('group_id', groupId);
    }else{
      query.eq('owner_id', userId);
    }

    final response = await query;
    return (response as List).map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>)).toList();
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
}
