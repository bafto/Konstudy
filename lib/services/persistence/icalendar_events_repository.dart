abstract class ICalendarEventsRepository{
  Future<List<Map<String, dynamic>>> loadUserEvents(String userId);
  Future<List<Map<String, dynamic>>> loadGroupEvents(String groupId);
  Future<Map<String, dynamic>?> getEventById(String id);
  Future<void> insertEvent(Map<String, dynamic> data);
  Future<void> updateEvent(String eventId, Map<String, dynamic> data);
  Future<void> deleteEvent(String eventId);
}