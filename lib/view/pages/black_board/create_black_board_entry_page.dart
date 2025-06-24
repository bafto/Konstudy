import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/black_board/black_board_controller_provider.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_provider.dart';
import 'package:konstudy/routes/app_routes.dart';

class CreateBlackBoardEntryPage extends ConsumerStatefulWidget {
  const CreateBlackBoardEntryPage({super.key});

  @override
  ConsumerState<CreateBlackBoardEntryPage> createState() =>
      _CreateBlackBoardEntryPageState();
}

class _CreateBlackBoardEntryPageState
    extends ConsumerState<CreateBlackBoardEntryPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blackBoardController = ref.watch(blackBoardControllerProvider);
    final groupsController = ref.watch(userGroupsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Eintrag erstellen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Beschreibung'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                groupsController.removeAllUsers();
                final group = await groupsController.groupCreate(
                  name: _nameController.text.trim(),
                  beschreibung: _descController.text.trim(),
                );

                await blackBoardController
                    .createEntry(
                      name: group.name,
                      description: group.description!,
                      groupId: group.id,
                    )
                    .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Eintrag wurde erstellt')),
                      );
                      HomeScreenRoute().go(context);
                    })
                    .catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bitte Namen und Beschreibung angeben'),
                        ),
                      );
                    });
              },
              child: Text('Eintrag erstellen'),
            ),
          ],
        ),
      ),
    );
  }
}
