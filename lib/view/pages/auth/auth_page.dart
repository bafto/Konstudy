import 'package:flutter/material.dart';
import 'package:konstudy/view/pages/auth/login_page.dart';
import 'package:konstudy/view/pages/auth/register_page.dart';

class AuthPage extends StatefulWidget{
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage>{
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    LoginPage(),
    RegisterPage(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
          BottomNavigationBarItem(icon: Icon(Icons.app_registration), label: 'Sign in'),
        ],
      ),
    );
  }
}