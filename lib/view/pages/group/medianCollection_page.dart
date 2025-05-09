import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/group/group_controller_provider.dart';
import 'package:konstudy/view/widgets/cards/MediaCard.dart';



class MedianCollectionPage extends ConsumerStatefulWidget{
  const MedianCollectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MedianCollectionPage();
}

class _MedianCollectionPage extends ConsumerState<MedianCollectionPage>{

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(groupControllerProvider).loadMedians();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _controller = ref.watch(groupControllerProvider);

    return Scaffold(
      body: ListView.builder(
          itemCount: _controller.medians.length,
          itemBuilder: (context, index){
            final media = _controller.medians[index];
            return MediaCard(
              filename: media.fileName,
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => debugPrint("new note"),
      ),
    );
  }
}