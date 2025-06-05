import 'package:flutter/material.dart';

class MediaCard extends StatelessWidget {
  final String filename;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  const MediaCard({
    super.key,
    required this.filename,
    required this.onDownload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                filename,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: 'Herunterladen',
              icon: const Icon(Icons.download_rounded),
              onPressed: onDownload,
            ),
            IconButton(
              tooltip: 'Löschen',
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}