import 'package:flutter/material.dart';
import 'package:konstudy/view/pages/calendar/AddEventPage.dart';
import 'package:konstudy/view/pages/calendar/EventDetailsPage.dart';
import 'package:konstudy/view/pages/group/group_page.dart';
import 'package:konstudy/view/pages/home/home_page.dart';
import 'package:calendar_view/calendar_view.dart';



class AppRoutes {
  static const String home = '/';
  static const String group = '/group';
  static const String addEvent = '/addEvent';
  static const String detailsEvent = '/detailsEvent';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case group:
        final groupName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => GroupPage(groupName: groupName),
        );

      case addEvent:
        return MaterialPageRoute(builder: (_) => const AddEventPage());

      case detailsEvent:
        final event = settings.arguments as CalendarEventData;
        return MaterialPageRoute(
            builder: (_) => EventDetailsPage(event: event)
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