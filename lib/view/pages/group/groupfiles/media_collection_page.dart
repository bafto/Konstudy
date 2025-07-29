import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/groupfiles/group_file_controller_provider.dart';
import 'package:konstudy/view/widgets/cards/media_card.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

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
              return MediaCard(
                filename: m.fileName,
                onDownload: () async {
                  await controller.downloadFile(m.filePath, m.fileName);
                },
                onDelete: () async {
                  await controller.deleteFile(m.filePath);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Datei-Upload wird bald verfügbar sein.'),
            ),
          );
          // TODO: Wegen Supabase Policies erstmal raus genommen
          /*
          final result = await FilePicker.platform.pickFiles();

          if (result != null && result.files.isNotEmpty) {
            final pickedFile = result.files.first;

            // PlatformFile hat keinen direkten File-Pfad auf allen Plattformen,
            // deshalb musst du prüfen ob der Pfad verfügbar ist:
            if (pickedFile.path != null) {
              final file = File(pickedFile.path!);

              try {
                await controller.uploadFile(widget.groupId, file);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${pickedFile.name} erfolgreich hochgeladen')),
                );
                setState(() {}); // Um die Liste neu zu laden
              } catch (e) {
                debugPrint('Upload Fehler: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fehler beim Hochladen: $e')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dateipfad konnte nicht ermittelt werden')),
              );
            }
          }
          */
        },
      ),
    );
  }
}
