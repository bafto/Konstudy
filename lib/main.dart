import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // HTWG Farben
    const KonstudyRed = Color(0xFFBD0034);
    const KonstudyDark = Color(0xFF232323);
    const KonstudyLightGrey = Color(0xFFE5E5E5);
    const KonstudyWhite = Colors.white;

    return MaterialApp.router(
      title: 'KonStudy',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: KonstudyRed,
          onPrimary: Colors.white,
          secondary: KonstudyDark,
          onSecondary: Colors.white,
          background: KonstudyWhite,
          onBackground: KonstudyDark,
          surface: KonstudyLightGrey,
          onSurface: KonstudyDark,
          error: Colors.red,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: KonstudyWhite,
        appBarTheme: const AppBarTheme(
          backgroundColor: KonstudyDark,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: KonstudyRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: KonstudyRed,
          onPrimary: Colors.white,
          secondary: KonstudyDark,
          onSecondary: Colors.white,
          background: KonstudyDark,
          onBackground: KonstudyWhite,
          surface: Color(0xFF1E1E1E),
          onSurface: KonstudyWhite,
          error: Colors.red,
          onError: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: KonstudyDark,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'), //Englisch
        Locale('de'), //Deutsch
      ],

      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
