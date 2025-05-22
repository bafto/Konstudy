import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/group/group_controller_provider.dart';
import 'package:konstudy/view/widgets/cards/media_card.dart';

class MedianCollectionPage extends ConsumerStatefulWidget {
  const MedianCollectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MedianCollectionPage();
}

class _MedianCollectionPage extends ConsumerState<MedianCollectionPage> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(groupControllerProvider);

    return Scaffold(
      body: FutureBuilder(
        future: controller.getMedia(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final media = snapshot.data!;
          return ListView.builder(
            itemCount: media.length,
            itemBuilder: (context, index) {
              final m = media[index];
              return MediaCard(filename: m.fileName);
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
