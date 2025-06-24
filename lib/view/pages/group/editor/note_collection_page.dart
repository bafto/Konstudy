import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/editor/note_controller_provider.dart';
import 'package:konstudy/models/editor/note.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/view/widgets/cards/note_card.dart';

class NoteCollectionPage extends ConsumerStatefulWidget {
  final String groupId;
  const NoteCollectionPage({super.key, required this.groupId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteCollectionPage();
}

class _NoteCollectionPage extends ConsumerState<NoteCollectionPage> {
  Widget _buildNoteCard(final Note note) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      child: NoteCard(note: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(noteControllerProvider);

    return Scaffold(
      body: FutureBuilder(
        future: controller.loadNotes(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Keine Notizen'));
          }

          return ListView(
            children: snapshot.data!.map(_buildNoteCard).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          NoteEditorPageRoute(groupId: widget.groupId).push<void>(context);
        },
      ),
    );
  }
}
