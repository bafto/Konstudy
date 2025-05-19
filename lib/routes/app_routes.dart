import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/controllers/auth/auth_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:calendar_view/calendar_view.dart';

import 'package:konstudy/view/pages/calendar/AddEventPage.dart';
import 'package:konstudy/view/pages/calendar/EditEventPage.dart';
import 'package:konstudy/view/pages/calendar/EventDetailsPage.dart';
import 'package:konstudy/view/pages/group/group_page.dart';
import 'package:konstudy/view/pages/home/home_page.dart';
import 'package:konstudy/view/pages/auth/auth_page.dart';
import 'package:konstudy/view/pages/auth/verification_CallBack_Page.dart';
import 'package:konstudy/view/pages/auth/verify_email_page.dart';



class AppRoutes {
  static const String home = '/';
  static const String group = '/group';
  static const String addEvent = '/addEvent';
  static const String detailsEvent = '/detailsEvent';
  static const String editEvent = '/editEvent';
  static const String auth = '/auth';
  static const String verificationCallback = '/verification-callback';
  static const String verifyEmail = '/verifyEmail';

  final GoRouter router = GoRouter(
    refreshListenable: AuthNotifier(),
    initialLocation: home,
    redirect: (context, state) {
      final user = Supabase.instance.client.auth.currentUser;
      final loggedIn = user != null;
      final loggingIn = state.path == auth;

      if(!loggedIn && !loggingIn){
        return auth;
      }
      if(loggedIn && loggingIn){
        return home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '$group/:groupName',
        name: 'group',
        builder: (context, state) {
          final groupName = state.pathParameters['groupName']!;
          return GroupPage(groupName: groupName);
        },
      ),
      GoRoute(
        path: addEvent,
        name: 'addEvent',
        builder: (context, state) => const AddEventPage(),
      ),
      GoRoute(
        path: detailsEvent,
        name: 'detailsEvent',
        builder: (context, state) {
          final event = state.extra as CalendarEventData;
          return EventDetailsPage(event: event);
        },
      ),
      GoRoute(
        path: editEvent,
        name: 'editEvent',
        builder: (context, state) {
          final event = state.extra as CalendarEventData;
          return EditEventPage(event: event);
        },
      ),
      GoRoute(
        path: auth,
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
          path: verificationCallback,
        name: 'verificationCallback',
        builder: (context, state) => const VerificationCallBackPage(),
      ),
      GoRoute(
        path: verifyEmail,
        name: 'verifyEmail',
        builder: (context, state) => const VerifyEmailPage(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Seite nicht gefunden')),
    ),
  );

}