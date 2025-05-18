import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vdwxhiuzrltxosgufkdu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkd3hoaXV6cmx0eG9zZ3Vma2R1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDczMDg5NDgsImV4cCI6MjA2Mjg4NDk0OH0.FT4lmBHYck0g-3nCF5kJyeU-CRfiSh1erCa8RP4fu58',
  );
  runApp(ProviderScope(child: Konstudy()));
}

class Konstudy extends StatelessWidget {
  const Konstudy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KonStudy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
