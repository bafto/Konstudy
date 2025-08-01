import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/provider/auth_provider.dart';
import 'package:konstudy/provider/black_board_provider.dart';
import 'package:konstudy/provider/user_groups_provider.dart';
import 'package:konstudy/routes/app_routes.dart';

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
    final userId = ref.watch(authControllerProvider.notifier).currentUser!.id;

    return entry.when(
      data:
          (entry) => Scaffold(
            appBar: AppBar(title: Text(entry.title)),
            body: Center(
              child: Column(
                children: [
                  Text(entry.description),
                  Text(entry.hashTags.join(" ")),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () async {
                groupController.addUserToGroup(
                  userId: userId,
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
