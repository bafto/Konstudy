import 'package:flutter/material.dart';
import 'package:konstudy/view/pages/group/groupCalendar_page.dart';
import 'package:konstudy/view/pages/group/medianCollection_page.dart';
import 'package:konstudy/view/pages/group/noteCollection_page.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.groupName});
  final String groupName;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  int _selectedIndex = 1;

  // Liste der Seiten, die angezeigt werden
  static const List<Widget> _pages = <Widget>[
    GroupCalendarPage(),
    NoteCollectionPage(),
    MedianCollectionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.groupName)),
        actions: [
          IconButton(
            onPressed: () => debugPrint("here"),
            icon: Icon(Icons.group),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Gruppenkalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_outlined),
            label: 'Notizen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_media_outlined),
            label: 'Median',
          ),
        ],
      ),
    );
  }
}
