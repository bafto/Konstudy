import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:konstudy/controllers/auth/auth_controller_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/routes/app_routes.dart';


class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // 🔹 Headline / App-Name
              const Text(
                "KonStudy", // <<< deinen App-Namen hier
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 40),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "E-Mail"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-Mail darf nicht leer sein';
                        }
                        const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                        if (!RegExp(pattern).hasMatch(value)) {
                          return 'Ungültige E-Mail-Adresse';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Passwort"),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Mindestens 6 Zeichen';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    state.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final scaffoldMessenger = ScaffoldMessenger.of(context);

                          try {
                            // Login-Methode, die Future<void> zurückgibt und bei Fehler wirft
                            await ref.read(authControllerProvider.notifier).login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            // Wenn kein Fehler: Zur HomePage weiterleiten
                            context.go(AppRoutes.home);
                          } catch (e) {
                            // Fehler abfangen und anzeigen
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text('Fehler: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
