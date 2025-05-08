import 'package:flutter/material.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/widgets/cards/GroupCard.dart';

class GroupOverview extends StatelessWidget {
  const GroupOverview({super.key});

  Widget _buildGroupCard(String name, String desc) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      child: GroupCard(
        name: name,
        description: desc,
        members: [
          Icon(Icons.account_circle),
          Icon(Icons.account_circle),
          Icon(Icons.account_circle),
          Icon(Icons.account_circle),
          Icon(Icons.account_circle),
          Icon(Icons.account_circle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildGroupCard("test name", "test"),
          _buildGroupCard("hallo", "desc"),
          ...List.generate(
            10,
            (_) => _buildGroupCard("Embedded Systems", "Beschreibung"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => debugPrint("new group"),
      ),
    );
  }
}
