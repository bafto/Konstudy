import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:konstudy/models/calendar/calendar_event.dart';
import 'package:konstudy/routes/app_routes.dart';

class CustomMonthView extends StatelessWidget {
  final EventController controller;

  const CustomMonthView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MonthView(
      controller: controller,
      onEventTap: (event, date) {
        //bei Month ist event keine Liste von events anders als bei den andern Views
        EventDetailsPageRoute(
          eventId: (event.event as CalendarEvent).id,
        ).push<void>(context);
      },
    );
  }
}
