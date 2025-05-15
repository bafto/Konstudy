import 'package:flutter/material.dart';
import 'package:konstudy/routes/AuthCheckWrapper.dart';
import 'package:konstudy/view/pages/calendar/AddEventPage.dart';
import 'package:konstudy/view/pages/calendar/EditEventPage.dart';
import 'package:konstudy/view/pages/calendar/EventDetailsPage.dart';
import 'package:konstudy/view/pages/group/group_page.dart';
import 'package:konstudy/view/pages/home/home_page.dart';
import 'package:calendar_view/calendar_view.dart';



class AppRoutes {
  static const String home = '/';
  static const String group = '/group';
  static const String addEvent = '/addEvent';
  static const String detailsEvent = '/detailsEvent';
  static const String editEvent = '/editEvent';
  static const String auth = '/auth';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const AuthCheckWrapper(child: HomePage()));

      case group:
        final groupName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => AuthCheckWrapper(child: GroupPage(groupName: groupName)),
        );

      case addEvent:
        return MaterialPageRoute(builder: (_) => const AuthCheckWrapper(child: AddEventPage()));

      case detailsEvent:
        final event = settings.arguments as CalendarEventData;
        return MaterialPageRoute(
            builder: (_) => AuthCheckWrapper(child: EventDetailsPage(event: event))
        );
        
      case editEvent:
        final event = settings.arguments as CalendarEventData;
        return MaterialPageRoute(
            builder: (_) => AuthCheckWrapper(child: EditEventPage(event: event))
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