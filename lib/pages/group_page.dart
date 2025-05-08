import 'package:flutter/material.dart';
import 'package:konstudy/pages/groupCalendar_page.dart';
import 'package:konstudy/pages/medianCollection_page.dart';
import 'package:konstudy/pages/noteCollection_page.dart';

class GroupPage extends StatefulWidget{
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage>{
  int _selectedIndex = 0;

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
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Meine App')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Gruppenkalender'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Notizen'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Median'),
        ],
      ),
    );
  }
}