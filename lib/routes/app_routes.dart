import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/controllers/auth/auth_notifier.dart';
import 'package:konstudy/view/pages/profile/user_profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:calendar_view/calendar_view.dart';

import 'package:konstudy/view/pages/calendar/add_event_page.dart';
import 'package:konstudy/view/pages/calendar/edit_event_page.dart';
import 'package:konstudy/view/pages/calendar/event_details_page.dart';
import 'package:konstudy/view/pages/group/group_page.dart';
import 'package:konstudy/view/pages/home/home_page.dart';
import 'package:konstudy/view/pages/auth/auth_page.dart';
import 'package:konstudy/view/pages/auth/verification_CallBack_Page.dart';
import 'package:konstudy/view/pages/auth/verify_email_page.dart';
import 'package:konstudy/routes/routes_paths.dart';



class AppRoutes {

  final GoRouter router = GoRouter(
    refreshListenable: AuthNotifier(),
    initialLocation: RoutesPaths.home,
    redirect: (context, state) {
      final user = Supabase.instance.client.auth.currentUser;
      final loggedIn = user != null;
      final loggingIn = state.path == RoutesPaths.auth;

      if(!loggedIn && !loggingIn){
        return RoutesPaths.auth;
      }
      if(loggedIn && loggingIn){
        return RoutesPaths.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutesPaths.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '${RoutesPaths.group}/:groupName',
        name: 'group',
        builder: (context, state) {
          final groupName = state.pathParameters['groupName']!;
          return GroupPage(groupName: groupName);
        },
      ),
      GoRoute(
        path: RoutesPaths.addEvent,
        name: 'addEvent',
        builder: (context, state) => const AddEventPage(),
      ),
      GoRoute(
        path: RoutesPaths.detailsEvent,
        name: 'detailsEvent',
        builder: (context, state) {
          final event = state.extra as CalendarEventData;
          return EventDetailsPage(event: event);
        },
      ),
      GoRoute(
        path: RoutesPaths.editEvent,
        name: 'editEvent',
        builder: (context, state) {
          final event = state.extra as CalendarEventData;
          return EditEventPage(event: event);
        },
      ),
      GoRoute(
        path: RoutesPaths.auth,
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
          path: RoutesPaths.verificationCallback,
        name: 'verificationCallback',
        builder: (context, state) => const VerificationCallBackPage(),
      ),
      GoRoute(
        path: RoutesPaths.verifyEmail,
        name: 'verifyEmail',
        builder: (context, state) => const VerifyEmailPage(),
      ),
      GoRoute(
        path: RoutesPaths.userProfil,
        name: 'userProfil',
        builder: (context, state) => const UserProfilePage(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Seite nicht gefunden')),
    ),
  );

}