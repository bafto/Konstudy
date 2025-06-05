import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_provider.dart';
import 'package:konstudy/routes/app_routes.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(userGroupsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Gruppe erstellen')),
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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Nutzer suchen'),
              onChanged: (value) {
                // ruft Suche im Controller auf
                ref.read(userGroupsControllerProvider).searchUser(value);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: controller.searchResult.length,
                itemBuilder: (context, index) {
                  final nutzer = controller.searchResult[index];
                  final selected = controller.selectedUsers.any(
                    (n) => n['id'] == nutzer['id'],
                  );
                  return ListTile(
                    title: Text(nutzer['name'].toString()),
                    subtitle: Text(nutzer['email'].toString()),
                    trailing: IconButton(
                      icon: Icon(
                        selected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                      onPressed: () {
                        final controllerNotifier = ref.read(
                          userGroupsControllerProvider,
                        );
                        if (selected) {
                          controllerNotifier.removeUser(nutzer);
                        } else {
                          controllerNotifier.addUser(nutzer);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await controller
                    .groupCreate(
                      name: _nameController.text.trim(),
                      beschreibung: _descController.text.trim(),
                    )
                    .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gruppe wurde erstellt')),
                      );
                      HomeScreenRoute().go(context);
                    })
                    .catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bitte Namen und Nutzer angeben'),
                        ),
                      );
                    });
              },
              child: Text('Gruppe erstellen'),
            ),
          ],
        ),
      ),
    );
  }
}
