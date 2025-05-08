import 'package:flutter/material.dart';
import 'package:konstudy/pages/group/group_page.dart';
import 'package:konstudy/pages/home/home_page.dart';


class AppRoutes {
  static const String home = '/';
  static const String group = '/group';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case group:
        final groupName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => GroupPage(groupName: groupName),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Seite nicht gefunden')),
          ),
        );
    }
  }
}