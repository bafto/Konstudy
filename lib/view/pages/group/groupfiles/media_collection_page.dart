import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/groupfiles/group_file_controller_provider.dart';
import 'package:konstudy/view/widgets/cards/media_card.dart';

class MedianCollectionPage extends ConsumerStatefulWidget {
  final String groupId;
  const MedianCollectionPage({super.key, required this.groupId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MedianCollectionPage();
}

class _MedianCollectionPage extends ConsumerState<MedianCollectionPage> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(groupFileControllerProvider);

    return Scaffold(
      body: FutureBuilder(
        future: controller.listFiles(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final media = snapshot.data!;
          return ListView.builder(
            itemCount: media.length,
            itemBuilder: (context, index) {
              final m = media[index];
              return MediaCard(filename: m.fileName, filePath: m.filePath,);
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
