import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/group/group_controller_provider.dart';
import 'package:konstudy/view/widgets/cards/note_card.dart';

class NoteCollectionPage extends ConsumerStatefulWidget {
  const NoteCollectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteCollectionPage();
}

class _NoteCollectionPage extends ConsumerState<NoteCollectionPage> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(groupControllerProvider);

    return Scaffold(
      body: FutureBuilder(
        future: controller.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(name: note.name, description: note.description);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => debugPrint("new note"),
      ),
    );
  }
}
