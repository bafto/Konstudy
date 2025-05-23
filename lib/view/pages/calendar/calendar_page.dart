import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';
import 'package:konstudy/models/calendar/repeat_type.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/view/widgets/views/custom_day_view.dart';
import 'package:konstudy/view/widgets/views/custom_month_view.dart';
import 'package:konstudy/view/widgets/views/custom_week_view.dart';

class CalendarPage extends ConsumerStatefulWidget {
  final String? groupId;
  const CalendarPage({super.key, this.groupId});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage>
    with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(calendarControllerProvider);

    return Scaffold(
      // Kein AppBar nötig, da du das in einer anderen Seite integriert hast
      body: Column(
        children: [
          // Tab-Leiste (nicht in der AppBar!)
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: 'Tag'),
              Tab(text: 'Woche'),
              Tab(text: 'Monat'),
            ],
          ),
          FutureBuilder(
            future: controller.getEvents(groupId: widget.groupId),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final events =
                  snapshot.data!.map((e) {
                    return CalendarEventData(
                      title: e.title,
                      date: e.start,
                      startTime: e.start,
                      endTime: e.end,
                      recurrenceSettings: mapRepeatTypeToRecurrenceSettings(
                        e.repeat,
                        e.start,
                      ),
                      event: e,
                      color: e.eventColor ?? Colors.grey,
                    );
                  }).toList();

              final eventController = EventController()..addAll(events);

              // Inhalte
              return Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    CustomDayView(controller: eventController),
                    CustomWeekView(controller: eventController),
                    CustomMonthView(controller: eventController),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          AddEventPageRoute(groupId: widget.groupId).push<void>(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  RecurrenceSettings? mapRepeatTypeToRecurrenceSettings(
    RepeatType repeatType,
    DateTime start,
  ) {
    switch (repeatType) {
      case RepeatType.none:
        return null;
      case RepeatType.daily:
        return RecurrenceSettings(
          startDate: start,
          frequency: RepeatFrequency.daily,
          recurrenceEndOn: RecurrenceEnd.never,
        );
      case RepeatType.weekly:
        return RecurrenceSettings(
          startDate: start,
          frequency: RepeatFrequency.weekly,
          recurrenceEndOn: RecurrenceEnd.never,
        );
      case RepeatType.monthly:
        return RecurrenceSettings(
          startDate: start,
          frequency: RepeatFrequency.monthly,
          recurrenceEndOn: RecurrenceEnd.never,
        );
      case RepeatType.yearly:
        return RecurrenceSettings(
          startDate: start,
          frequency: RepeatFrequency.yearly,
          recurrenceEndOn: RecurrenceEnd.never,
        );
    }
  }
}
