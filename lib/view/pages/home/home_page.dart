import 'package:flutter/material.dart';
import 'package:konstudy/view/pages/home/GroupOverview.dart';
import 'package:konstudy/view/pages/home/blackBoard_page.dart';
import 'package:konstudy/view/pages/home/my_calendar_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int _selectedIndex = 1;

  static const List<Widget> _pages = <Widget>[
    MyCalendarPage(),
    GroupOverview(),
    BlackBoardPage(),
  ];

  static const List<String> _titles = <String>[
    'Mein Kalender',
    'Gruppen',
    'Schwarzes Brett',
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_titles[_selectedIndex])),
        actions: [
          IconButton(
              onPressed: () => debugPrint("here"),
              icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar:BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Mein Kalender'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Gruppen'),
          BottomNavigationBarItem(icon: Icon(Icons.sticky_note_2_rounded), label: 'Schwarzes Brett'),
        ],
      ),
    );
  }

}