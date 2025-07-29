import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/view/pages/home/black_board_page.dart';
import 'package:konstudy/view/pages/home/group_overview.dart';
import 'package:konstudy/view/pages/calendar/calendar_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.pageBuilders});

  /// Optional: zum Ersetzen einzelner Seiten im Test
  final List<WidgetBuilder>? pageBuilders;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 1;

  late final List<WidgetBuilder> _pages = widget.pageBuilders ??
      [
            (context) => CalendarPage(),
            (context) => Groupoverview(),
            (context) => BlackBoardPage(),
      ];

  static const List<String> _titles = [
    'Mein Kalender',
    'Gruppen',
    'Schwarzes Brett',
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
        title: Center(child: Text(_titles[_selectedIndex])),
        actions: [
          IconButton(
            onPressed: () => UserProfilePageRoute().push<void>(context),
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: _pages[_selectedIndex](context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Mein Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Gruppen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_rounded),
            label: 'Schwarzes Brett',
          ),
        ],
      ),
    );
  }
}
