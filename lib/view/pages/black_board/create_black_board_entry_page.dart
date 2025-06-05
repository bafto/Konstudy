import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/black_board/black_board_controller_provider.dart';
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
    final controller = ref.watch(blackBoardControllerProvider);

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
                await controller
                    .createEntry(
                      name: _nameController.text.trim(),
                      description: _descController.text.trim(),
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
