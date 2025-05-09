import 'package:flutter/material.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/view/widgets/InitialsIcon.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    required this.name,
    required this.description,
    required this.members,
    super.key,
  });

  final String name;
  final String description;
  final List<Icon> members;

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
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
            context,
            AppRoutes.group,
            arguments: name,
        );
      }, //Aktion bei Klick
      child: Card(
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
                        ...members
                            .map(
                              (icon) => Padding(
                            padding: EdgeInsets.only(right: 2.5),
                            child: icon,
                          ),
                        )
                            .take(5),
                        if (members.length > 5)
                          const Text(
                            "...",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );

  }
}
