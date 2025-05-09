import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/group/group_controller_provider.dart';
import 'package:konstudy/view/widgets/cards/NoteCard.dart';

class NoteCollectionPage extends ConsumerStatefulWidget{
  const NoteCollectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteCollectionPage();
}
class _NoteCollectionPage extends ConsumerState<NoteCollectionPage>{

  @override
  void initState(){
    super.initState();

    Future.microtask(() {
      ref.read(groupControllerProvider).loadNotes();
    });
  }

  @override
  Widget build(BuildContext context){
    final _controller = ref.watch(groupControllerProvider);

    return Scaffold(
      body: ListView.builder(
          itemCount: _controller.notes.length,
          itemBuilder: (context, index){
            final note = _controller.notes[index];
            return NoteCard(
              name: note.name,
              description: note.description,
            );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => debugPrint("new note"),
      ),
    );
  }
}