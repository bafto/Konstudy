import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:konstudy/view/pages/calendar/AddEventPage.dart';
import 'package:konstudy/view/pages/calendar/EditEventPage.dart';
import 'package:konstudy/view/pages/calendar/EventDetailsPage.dart';
import 'package:konstudy/view/pages/group/group_page.dart';
import 'package:konstudy/view/pages/home/home_page.dart';

// TODO: use goroute
class AppRoutes {
  static const home = '/';
  static const group = '/group';
  static const addEvent = '/addEvent';
  static const detailsEvent = '/detailsEvent';
  static const editEvent = '/editEvent';

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
          builder: (_) => EventDetailsPage(event: event),
        );

      case editEvent:
        final event = settings.arguments as CalendarEventData;
        return MaterialPageRoute(builder: (_) => EditEventPage(event: event));

      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Seite nicht gefunden')),
              ),
        );
    }
  }
}
