// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeScreenRoute];

RouteBase get $homeScreenRoute => GoRouteData.$route(
  path: '/',

  factory: $HomeScreenRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: 'group/:groupName',

      factory: $GroupPageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'addEvent',

      factory: $AddEventPageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'detailsEvent',

      factory: $EventDetailsPageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'editEvent',

      factory: $EditEventPageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'auth',

      factory: $AuthPageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'verificationCallback',

      factory: $VerificationCallBackPageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'verifyEmail',

      factory: $VerifyEmailPageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'userProfile',

      factory: $UserProfilePageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'createGroup',

      factory: $CreateGroupPageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'noteEditor',

      factory: $NoteEditorPageRouteExtension._fromState,
    ),
  ],
);

extension $HomeScreenRouteExtension on HomeScreenRoute {
  static HomeScreenRoute _fromState(GoRouterState state) =>
      const HomeScreenRoute();

  String get location => GoRouteData.$location('/');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $GroupPageRouteExtension on GroupPageRoute {
  static GroupPageRoute _fromState(GoRouterState state) => GroupPageRoute(
    groupName: state.pathParameters['groupName']!,
    groupId: state.uri.queryParameters['group-id']!,
  );

  String get location => GoRouteData.$location(
    '/group/${Uri.encodeComponent(groupName)}',
    queryParams: {'group-id': groupId},
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AddEventPageRouteExtension on AddEventPageRoute {
  static AddEventPageRoute _fromState(GoRouterState state) =>
      AddEventPageRoute(groupId: state.uri.queryParameters['group-id']);

  String get location => GoRouteData.$location(
    '/addEvent',
    queryParams: {if (groupId != null) 'group-id': groupId},
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EventDetailsPageRouteExtension on EventDetailsPageRoute {
  static EventDetailsPageRoute _fromState(GoRouterState state) =>
      EventDetailsPageRoute(eventId: state.uri.queryParameters['event-id']!);

  String get location => GoRouteData.$location(
    '/detailsEvent',
    queryParams: {'event-id': eventId},
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditEventPageRouteExtension on EditEventPageRoute {
  static EditEventPageRoute _fromState(GoRouterState state) =>
      EditEventPageRoute(eventId: state.uri.queryParameters['event-id']!);

  String get location =>
      GoRouteData.$location('/editEvent', queryParams: {'event-id': eventId});

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AuthPageRouteExtension on AuthPageRoute {
  static AuthPageRoute _fromState(GoRouterState state) => const AuthPageRoute();

  String get location => GoRouteData.$location('/auth');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $VerificationCallBackPageRouteExtension
    on VerificationCallBackPageRoute {
  static VerificationCallBackPageRoute _fromState(GoRouterState state) =>
      const VerificationCallBackPageRoute();

  String get location => GoRouteData.$location('/verificationCallback');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $VerifyEmailPageRouteExtension on VerifyEmailPageRoute {
  static VerifyEmailPageRoute _fromState(GoRouterState state) =>
      VerifyEmailPageRoute();

  String get location => GoRouteData.$location('/verifyEmail');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserProfilePageRouteExtension on UserProfilePageRoute {
  static UserProfilePageRoute _fromState(GoRouterState state) =>
      const UserProfilePageRoute();

  String get location => GoRouteData.$location('/userProfile');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CreateGroupPageRouteExtension on CreateGroupPageRoute {
  static CreateGroupPageRoute _fromState(GoRouterState state) =>
      const CreateGroupPageRoute();

  String get location => GoRouteData.$location('/createGroup');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NoteEditorPageRouteExtension on NoteEditorPageRoute {
  static NoteEditorPageRoute _fromState(GoRouterState state) =>
      NoteEditorPageRoute(
        noteId: state.uri.queryParameters['note-id'],
        groupId: state.uri.queryParameters['group-id']!,
      );

  String get location => GoRouteData.$location(
    '/noteEditor',
    queryParams: {if (noteId != null) 'note-id': noteId, 'group-id': groupId},
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
