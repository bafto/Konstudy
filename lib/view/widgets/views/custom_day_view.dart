import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:konstudy/routes/app_routes.dart';

class CustomDayView extends StatelessWidget {
  final EventController controller;

  const CustomDayView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DayView(
      controller: controller,
      onEventTap: (events, date) {
        final tappedEvent =
            events
                .first; //die Lösung ist nicht 100%sicher das es wirklich immer die ist auf die geklicked wurde
        Navigator.pushNamed(
          context,
          AppRoutes.detailsEvent,
          arguments: tappedEvent,
        );
      },
    );
  }
}
