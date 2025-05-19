import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }
}