import 'package:konstudy/services/persistence/icalendar_events_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCalendarEventRepository implements ICalendarEventsRepository {
  final SupabaseClient _client;

  SupabaseCalendarEventRepository(this._client);

  @override
  Future<List<Map<String, dynamic>>> loadUserEvents(String userId) async {
    final groupIdsResponse = await _client
        .from('group_members')
        .select('group_id')
        .eq('user_id', userId);

    final groupIds = (groupIdsResponse as List)
        .map((e) => e['group_id'] as String)
        .toList();

    final orClause = groupIds.isNotEmpty
        ? 'owner_id.eq.$userId,group_id.in.(${groupIds.join(',')})'
        : 'owner_id.eq.$userId';

    final result = await _client
        .from('calendar_events')
        .select()
        .or(orClause);

    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<List<Map<String, dynamic>>> loadGroupEvents(String groupId) async {
    final memberIdsResponse = await _client
        .from('group_members')
        .select('user_id')
        .eq('group_id', groupId);

    final memberIds = (memberIdsResponse as List)
        .map((e) => e['user_id'] as String)
        .toList();

    final orClause =
        'group_id.eq.$groupId,and(group_id.is.null,owner_id.in.(${memberIds.join(',')}))';

    final result = await _client
        .from('calendar_events')
        .select()
        .or(orClause);

    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<Map<String, dynamic>?> getEventById(String id) async {
    final result = await _client
        .from('calendar_events')
        .select()
        .eq('id', id)
        .maybeSingle();
    return result;
  }

  @override
  Future<void> insertEvent(Map<String, dynamic> data) {
    return _client.from('calendar_events').insert(data);
  }

  @override
  Future<void> updateEvent(String eventId, Map<String, dynamic> data) {
    return _client
        .from('calendar_events')
        .update(data)
        .eq('id', eventId);
  }

  @override
  Future<void> deleteEvent(String eventId) {
    return _client.from('calendar_events').delete().eq('id', eventId);
  }
}
