import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/provider/note_provider.dart';
import 'package:konstudy/models/editor/note.dart';
import 'package:konstudy/routes/app_routes.dart';

class NoteCard extends ConsumerWidget {
  const NoteCard({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Notiz öffnen'),
                  onTap: () {
                    Navigator.of(context).pop();
                    NoteEditorPageRoute(
                      noteId: note.id,
                      groupId: note.groupId,
                    ).push<void>(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Löschen',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();

                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Notiz löschen?'),
                            content: const Text(
                              'Willst du die Notiz wirklich löschen?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Abbrechen'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Dialog schließen

                                  try {
                                    await ref
                                        .read(noteControllerProvider)
                                        .deleteNote(note.id);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Notiz gelöscht'),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Fehler: $e')),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Löschen',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      child: Card(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Text("Bearbeitet von"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
