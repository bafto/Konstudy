import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/black_board/black_board_controller_provider.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_provider.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlackBoardEntryPage extends ConsumerStatefulWidget {
  final String entryId;

  const BlackBoardEntryPage({super.key, required this.entryId});

  @override
  ConsumerState<BlackBoardEntryPage> createState() =>
      _BlackBoardEntryPageState();
}

class _BlackBoardEntryPageState extends ConsumerState<BlackBoardEntryPage> {
  @override
  Widget build(BuildContext context) {
    final entry = ref.watch(blackBoardEntryProvider(widget.entryId));
    final groupController = ref.watch(userGroupsControllerProvider);
    final client = Supabase.instance.client;

    return entry.when(
      data:
          (entry) => Scaffold(
            appBar: AppBar(title: Text(entry.title)),
            body: Center(child: Column(children: [Text(entry.description)])),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () async {
                debugPrint(
                  'adding ${client.auth.currentUser!.id} to ${entry.groupId}',
                );
                groupController.addUserToGroup(
                  userId: client.auth.currentUser!.id,
                  groupId: entry.groupId,
                );

                final group = await groupController.getGroupById(entry.groupId);
                GroupPageRoute(
                  groupName: group.name,
                  groupId: group.id,
                ).go(context);
              },
            ),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (err, _) => Scaffold(
            appBar: AppBar(title: Text('Fehler')),
            body: Center(child: Text('Fehler beim Laden: $err')),
          ),
    );
  }
}
