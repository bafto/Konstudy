import 'package:flutter/material.dart';
import 'package:konstudy/widgets/InitialsIcon.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({required this.name, required this.description, super.key});

  final String name;
  final String description;

  String _getInitials() {
    const emptyDefault = "GR";
    if (name.trim().isEmpty) {
      return emptyDefault;
    }

    final words = name.trim().split(' ');
    if (words.length < 2) {
      return words.firstOrNull ?? emptyDefault;
    }

    final initials =
        (words.first.trim().characters.first + words[1].trim().characters.first)
            .trim();
    return initials.isNotEmpty ? initials : emptyDefault;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 5, top: 10),
                child: InitialsIcon(initials: _getInitials()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(description),
                  Row(
                    children: [
                      Icon(Icons.account_circle),
                      Icon(Icons.account_circle),
                      Icon(Icons.account_circle),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
