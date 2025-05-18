import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:konstudy/controllers/calendar/calendar_controller_provider.dart';
import 'package:konstudy/routes/auth_check_wrapper.dart';
import 'package:konstudy/view/pages/calendar/add_event_page.dart';
import 'package:konstudy/view/pages/calendar/edit_event_page.dart';
import 'package:konstudy/view/pages/calendar/event_details_page.dart';
import 'package:konstudy/view/pages/group/group_page.dart';
import 'package:konstudy/view/pages/home/home_page.dart';

part 'app_routes.g.dart';

@TypedGoRoute<HomeScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<GroupPageRoute>(path: 'group/:groupName'),
    TypedGoRoute<AddEventPageRoute>(path: 'addEvent'),
    TypedGoRoute<EventDetailsPageRoute>(path: 'detailsEvent'),
    TypedGoRoute<EditEventPageRoute>(path: 'editEvent'),
    TypedGoRoute(path: 'auth'),
  ],
)
class HomeScreenRoute extends GoRouteData {
  const HomeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthCheckWrapper(child: HomePage());
  }
}

class GroupPageRoute extends GoRouteData {
  final String groupName;
  const GroupPageRoute({required this.groupName});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AuthCheckWrapper(child: GroupPage(groupName: groupName));
  }
}

class AddEventPageRoute extends GoRouteData {
  const AddEventPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthCheckWrapper(child: AddEventPage());
  }
}

class EventDetailsPageRoute extends GoRouteData {
  final int eventId;
  const EventDetailsPageRoute({required this.eventId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AuthCheckWrapper(
      child: Consumer(
        builder: (context, ref, child) {
          final event = ref.watch(eventByIdProvider(eventId));
          return event.when(
            data: (event) => EventDetailsPage(event: event!),
            error: (error, stack) => const Center(child: Text('Fehler')),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class EditEventPageRoute extends GoRouteData {
  final int eventId;
  const EditEventPageRoute({required this.eventId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AuthCheckWrapper(
      child: Consumer(
        builder: (context, ref, child) {
          final event = ref.watch(eventByIdProvider(eventId));
          return event.when(
            data: (event) => EditEventPage(event: event!),
            error: (error, stack) => const Center(child: Text('Fehler')),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: $appRoutes,
  errorBuilder: (context, state) {
    return const Scaffold(
      body: Center(child: Text('Fehler: Seite nicht gefunden')),
    );
  },
);
