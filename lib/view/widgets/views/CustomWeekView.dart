import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:konstudy/routes/app_routes.dart';

class CustomWeekView extends StatelessWidget {
  final EventController controller;

  const CustomWeekView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return WeekView(
      controller: controller,
      onEventTap: (events, date){
        final tappedEvent = events.first; //die Lösung ist nicht 100%sicher das es wirklich immer die ist auf die geklicked wurde

        Navigator.pushNamed(
            context,
            AppRoutes.detailsEvent,
            arguments: tappedEvent
        );
      },
    );
  }
}