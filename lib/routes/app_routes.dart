import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/controllers/auth/auth_notifier.dart';
import 'package:konstudy/view/pages/auth/auth_page.dart';
import 'package:konstudy/view/pages/auth/verification_CallBack_Page.dart';
import 'package:konstudy/view/pages/auth/verify_email_page.dart';
import 'package:konstudy/view/pages/calendar/add_event_page.dart';
import 'package:konstudy/view/pages/calendar/edit_event_page.dart';
import 'package:konstudy/view/pages/calendar/event_details_page.dart';
import 'package:konstudy/view/pages/group/group_page.dart';
import 'package:konstudy/view/pages/home/group_create_page.dart';
import 'package:konstudy/view/pages/home/home_page.dart';
import 'package:konstudy/view/pages/profile/user_profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_routes.g.dart';

@TypedGoRoute<HomeScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<GroupPageRoute>(path: 'group/:groupName'),
    TypedGoRoute<AddEventPageRoute>(path: 'addEvent'),
    TypedGoRoute<EventDetailsPageRoute>(path: 'detailsEvent'),
    TypedGoRoute<EditEventPageRoute>(path: 'editEvent'),
    TypedGoRoute<AuthPageRoute>(path: 'auth'),
    TypedGoRoute<VerificationCallBackPageRoute>(path: 'verificationCallback'),
    TypedGoRoute<VerifyEmailPageRoute>(path: 'verifyEmail'),
    TypedGoRoute<UserProfilePageRoute>(path: 'userProfile'),
    TypedGoRoute<CreateGroupPageRoute>(path: 'createGroup'),
  ],
)
class HomeScreenRoute extends GoRouteData {
  const HomeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

class GroupPageRoute extends GoRouteData {
  final String groupName;
  const GroupPageRoute({required this.groupName});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GroupPage(groupName: groupName);
  }
}

class CreateGroupPageRoute extends GoRouteData {
  const CreateGroupPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateGroupPage();
  }
}

class AddEventPageRoute extends GoRouteData {
  const AddEventPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddEventPage();
  }
}

class EventDetailsPageRoute extends GoRouteData {
  final int eventId;
  const EventDetailsPageRoute({required this.eventId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EventDetailsPage(eventId: eventId);
  }
}

class EditEventPageRoute extends GoRouteData {
  final int eventId;
  const EditEventPageRoute({required this.eventId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditEventPage(eventId: eventId);
  }
}

class AuthPageRoute extends GoRouteData {
  const AuthPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthPage();
  }
}

class VerificationCallBackPageRoute extends GoRouteData {
  const VerificationCallBackPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VerificationCallBackPage();
  }
}

class VerifyEmailPageRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VerifyEmailPage();
  }
}

class UserProfilePageRoute extends GoRouteData {
  const UserProfilePageRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserProfilePage();
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  refreshListenable: AuthNotifier(),
  routes: $appRoutes,
  redirect: (context, state) {
    final user = Supabase.instance.client.auth.currentUser;
    final loggedIn = user != null;
    const authRoute = AuthPageRoute();
    final loggingIn = state.fullPath == authRoute.location;

    if (!loggedIn && !loggingIn) {
      return authRoute.location;
    }
    if (loggedIn && loggingIn) {
      return const HomeScreenRoute().location;
    }
    return null;
  },
  errorBuilder: (context, state) {
    return const Scaffold(
      body: Center(child: Text('Fehler: Seite nicht gefunden')),
    );
  },
);
