import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/black_board/black_board_controller_provider.dart';
import 'package:konstudy/controllers/profile/user_profil_controller_provider.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_provider.dart';
import 'package:konstudy/models/black_board/black_board_entry.dart';
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
    final controller = ref.watch(blackBoardControllerProvider);
    final groupController = ref.watch(userGroupsControllerProvider);
    final userController = ref.watch(userProfilControllerProvider);
    final client = Supabase.instance.client;

    return FutureBuilder<BlackBoardEntry>(
      future: controller.getEntryById(id: widget.entryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Lade...')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final entry = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: Text(entry.title)),
          body: Center(child: Column(children: [Text(entry.description)])),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final creator = await userController.fetchUserProfileById(
                id: entry.creatorId,
              );
              final requester = await userController.fetchUserProfile();
              groupController.removeAllUsers();
              groupController.addUser(creator);
              groupController.addUser(requester);
              final group = await groupController.groupCreate(
                name: entry.title,
                beschreibung: entry.description,
              );

              groupController.addUserToGroup(
                userId: client.auth.currentUser!.id,
                groupId: entry.groupId,
              );
              GroupPageRoute(
                groupName: group.name,
                groupId: group.id,
              ).go(context);
            },
          ),
        );
      },
    );
  }
}
