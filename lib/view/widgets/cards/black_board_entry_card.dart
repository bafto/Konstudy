import 'package:flutter/material.dart';
import 'package:konstudy/models/black_board/black_board_entry.dart';
import 'package:konstudy/routes/app_routes.dart';

class BlackBoardEntryCard extends StatelessWidget {
  const BlackBoardEntryCard({required this.entry, super.key});

  final BlackBoardEntry entry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlackBoardEntryPageRoute(entryId: entry.id).push<void>(context);
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
                      entry.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(entry.description),
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
