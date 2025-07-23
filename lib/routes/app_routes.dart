import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/controllers/auth/auth_notifier.dart';
import 'package:konstudy/view/pages/auth/auth_page.dart';
import 'package:konstudy/view/pages/auth/verification_CallBack_Page.dart';
import 'package:konstudy/view/pages/auth/verify_email_page.dart';
import 'package:konstudy/view/pages/black_board/black_board_entry_page.dart';
import 'package:konstudy/view/pages/black_board/create_black_board_entry_page.dart';
import 'package:konstudy/view/pages/calendar/add_event_page.dart';
import 'package:konstudy/view/pages/calendar/edit_event_page.dart';
import 'package:konstudy/view/pages/calendar/event_details_page.dart';
import 'package:konstudy/view/pages/group/editor/note_editor_page.dart';
import 'package:konstudy/view/pages/group/group_page.dart';
import 'package:konstudy/view/pages/home/group_create_page.dart';
import 'package:konstudy/view/pages/home/home_page.dart';
import 'package:konstudy/view/pages/profile/group_profile_page.dart';
import 'package:konstudy/view/pages/profile/user_profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_routes.g.dart';

@TypedGoRoute<HomeScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<GroupPageRoute>(path: 'group/:groupName'),
    TypedGoRoute<BlackBoardEntryPageRoute>(path: 'blackBoard/:entryId'),
    TypedGoRoute<AddEventPageRoute>(path: 'addEvent'),
    TypedGoRoute<EventDetailsPageRoute>(path: 'detailsEvent'),
    TypedGoRoute<EditEventPageRoute>(path: 'editEvent'),
    TypedGoRoute<AuthPageRoute>(path: 'auth'),
    TypedGoRoute<VerificationCallBackPageRoute>(path: 'verificationCallback'),
    TypedGoRoute<VerifyEmailPageRoute>(path: 'verifyEmail'),
    TypedGoRoute<UserProfilePageRoute>(path: 'userProfile'),
    TypedGoRoute<GroupProfilPageRoute>(path: 'groupProfile'),
    TypedGoRoute<CreateGroupPageRoute>(path: 'createGroup'),
    TypedGoRoute<CreateBlackBoardEntryPageRoute>(path: 'createBlackBoardEntry'),
    TypedGoRoute<NoteEditorPageRoute>(path: 'noteEditor'),
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
  final String groupId;
  const GroupPageRoute({required this.groupName, required this.groupId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GroupPage(groupName: groupName, groupId: groupId);
  }
}

class CreateGroupPageRoute extends GoRouteData {
  const CreateGroupPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateGroupPage();
  }
}

class BlackBoardEntryPageRoute extends GoRouteData {
  final String entryId;
  const BlackBoardEntryPageRoute({required this.entryId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlackBoardEntryPage(entryId: entryId);
  }
}

class CreateBlackBoardEntryPageRoute extends GoRouteData {
  const CreateBlackBoardEntryPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateBlackBoardEntryPage();
  }
}

class AddEventPageRoute extends GoRouteData {
  final String? groupId;
  const AddEventPageRoute({required this.groupId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddEventPage(groupId: groupId);
  }
}

class EventDetailsPageRoute extends GoRouteData {
  final String eventId;
  const EventDetailsPageRoute({required this.eventId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EventDetailsPage(eventId: eventId);
  }
}

class EditEventPageRoute extends GoRouteData {
  final String eventId;
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
  final String? userId;
  const UserProfilePageRoute({this.userId});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserProfilePage(userId: userId);
  }
}

class GroupProfilPageRoute extends GoRouteData {
  final String groupId;
  const GroupProfilPageRoute({required this.groupId});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GroupProfilePage(groupId: groupId);
  }
}

class NoteEditorPageRoute extends GoRouteData {
  const NoteEditorPageRoute({this.noteId, required this.groupId});
  final String? noteId;
  final String groupId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NoteEditorPage(noteId: noteId, groupId: groupId);
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
