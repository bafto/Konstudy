import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:konstudy/routes/routes_paths.dart';

class CustomMonthView extends StatelessWidget {
  final EventController controller;

  const CustomMonthView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MonthView(
      controller: controller,
      onEventTap: (event, date) {
        //bei Month ist event keine Liste von events anders als bei den andern Views
        Navigator.pushNamed(context, RoutesPaths.detailsEvent, arguments: event);
      },
    );
  }
}
