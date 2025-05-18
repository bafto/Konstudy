import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({required this.name, required this.description, super.key});

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(description),
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
