// widgets/auth_check_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:konstudy/view/pages/auth/auth_page.dart';

class AuthCheckWrapper extends ConsumerWidget {
  final Widget child;
  const AuthCheckWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const AuthPage(); // Nutzer nicht eingeloggt
    } else {
      return child; // Nutzer eingeloggt
    }
  }
}