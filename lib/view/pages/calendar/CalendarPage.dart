import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/view/widgets/views/CustomDayView.dart';
import 'package:konstudy/view/widgets/views/CustomMonthView.dart';
import 'package:konstudy/view/widgets/views/CustomWeekView.dart';
import 'package:konstudy/models/calendar/RepeatType.dart';


class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    //Future.microtask(() async{
    //  await ref.read(calendarControllerProvider).loadEvents(); // falls asynchrones Laden
    //});
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(calendarControllerProvider);

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final events = controller.events.map((e) {
      return CalendarEventData(
        title: e.title,
        date: e.start,
        startTime: e.start,
        endTime: e.end,
        recurrenceSettings: mapRepeatTypeToRecurrenceSettings(e.repeat, e.start),
        event: e,
      );
    }).toList();

    final eventController = EventController()..addAll(events);

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
          // Inhalte
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CustomDayView(controller: eventController),
                CustomWeekView(controller: eventController),
                CustomMonthView(controller: eventController),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await context.push(AppRoutes.addEvent);

          if (result != null) {
            await ref.read(calendarControllerProvider).loadEvents();
          }
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
      case RepeatType.NONE:
        return null;
      case RepeatType.DAILY:
        return RecurrenceSettings(
          startDate: start,
          frequency: RepeatFrequency.daily,
          recurrenceEndOn: RecurrenceEnd.never,
        );
      case RepeatType.WEEKLY:
        return RecurrenceSettings(
          startDate: start,
          frequency: RepeatFrequency.weekly,
          recurrenceEndOn: RecurrenceEnd.never,
        );
      case RepeatType.MONTHLY:
        return RecurrenceSettings(
          startDate: start,
          frequency: RepeatFrequency.monthly,
          recurrenceEndOn: RecurrenceEnd.never,
        );
      case RepeatType.YEARLY:
        return RecurrenceSettings(
          startDate: start,
          frequency: RepeatFrequency.yearly,
          recurrenceEndOn: RecurrenceEnd.never,
        );
    }
  }


}





