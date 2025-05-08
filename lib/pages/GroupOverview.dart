import 'package:flutter/material.dart';
import 'package:konstudy/widgets/GroupCard.dart';

class GroupOverview extends StatelessWidget {
  const GroupOverview({super.key});

  Widget _buildGroupCard(String name, String desc) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      child: GroupCard(name: name, description: desc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Gruppen")),
        actions: [
          IconButton(
            onPressed: () => debugPrint("here"),
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
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
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.today),
            label: "Mein Kalender",
          ),
          NavigationDestination(icon: Icon(Icons.groups), label: "Gruppen"),
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2_rounded),
            label: "Schwarzes Brett",
          ),
        ],
      ),
    );
  }
}
