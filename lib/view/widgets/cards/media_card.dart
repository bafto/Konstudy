import 'package:flutter/material.dart';

class MediaCard extends StatelessWidget {
  final String filename;
  final String filePath;

  const MediaCard({super.key, required this.filename, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Noch keine Logik – nur Klick-Erkennung
          debugPrint('Card geklickt: $filename');
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.download_rounded),
                const SizedBox(width: 12),
                Text(filename, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
