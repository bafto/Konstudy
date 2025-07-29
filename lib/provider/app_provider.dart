import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/services/persistence/Supabase/supabase_users_repository.dart';
import 'package:konstudy/services/persistence/icalendar_events_repository.dart';
import 'package:konstudy/services/persistence/iusers_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/persistence/Supabase/supabase_black_board_entries_repository.dart';
import '../services/persistence/Supabase/supabase_calender_event_repository.dart';
import '../services/persistence/Supabase/supabase_group_file_repository.dart';
import '../services/persistence/Supabase/supabase_group_notes_repository.dart';
import '../services/persistence/Supabase/supabase_groups_repository.dart';
import '../services/persistence/iblack_board_entries_repository.dart';
import '../services/persistence/igroup_file_repository.dart';
import '../services/persistence/igroup_notes_repository.dart';
import '../services/persistence/igroups_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final groupRepositoryProvider = Provider<IGroupRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseGroupRepository(client);
});

final usersRepositoryProvider = Provider<IUserRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseUsersRepository(client);
});

final calendarEventRepositoryProvider = Provider<ICalendarEventsRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseCalendarEventRepository(client);
});

final groupFileRepositoryProvider = Provider<IGroupFileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseGroupFileRepository(bucket: 'groupfiles', client: client);
});

final noteRepositoryProvider = Provider<IGroupNotesRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseGroupNotesRepository(client);
});

final blackBoardRepositoryProvider = Provider<IBlackBoardEntriesRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseBlackBoardEntriesRepository(client);
});