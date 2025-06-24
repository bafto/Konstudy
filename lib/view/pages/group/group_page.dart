import 'package:flutter/material.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/view/pages/calendar/calendar_page.dart';
import 'package:konstudy/view/pages/group/editor/note_collection_page.dart';
import 'package:konstudy/view/pages/group/groupfiles/media_collection_page.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.groupName, required this.groupId});
  final String groupName;
  final String groupId;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  int _selectedIndex = 1;
  late final List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    //Liste aller Seiten die angezeigt werden
    _pages = [
      CalendarPage(groupId: widget.groupId),
      NoteCollectionPage(groupId: widget.groupId),
      MedianCollectionPage(groupId: widget.groupId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            HomeScreenRoute().go(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Center(child: Text(widget.groupName)),
        actions: [
          IconButton(
            onPressed: () => GroupProfilPageRoute(groupId: widget.groupId).push<void>(context),
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
