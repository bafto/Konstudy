import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_provider.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/routes/app_routes.dart';

class CreateGroupPage extends ConsumerWidget {
  CreateGroupPage({super.key});

  final _nameController = TextEditingController(text: 'Meine Gruppe');
  final _descriptionController = TextEditingController(
    text: 'Gruppen Beschreibung',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(userGroupsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Gruppe Erstellen')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(controller: _nameController),
            TextFormField(controller: _descriptionController),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Group g = await controller.addGroup(
            Group(
              id: 0,
              name: _nameController.text,
              description: _descriptionController.text,
              memberNames: [],
            ),
          );
          GroupPageRoute(groupName: g.name).pushReplacement(context);
        },
        child: const Icon(Icons.check_sharp),
      ),
    );
  }
}
