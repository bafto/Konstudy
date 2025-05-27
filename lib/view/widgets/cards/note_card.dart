import 'package:flutter/material.dart';
import 'package:konstudy/models/editor/note.dart';
import 'package:konstudy/routes/app_routes.dart';



class NoteCard extends StatelessWidget {
  const NoteCard({required this.note , super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NoteEditorPageRoute(noteId: note.id, groupId: note.groupId).push<void>(context);
      },
      child: Card(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text("Bearbeitet von"),
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
