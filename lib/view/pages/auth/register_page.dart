import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/auth/auth_controller_provider.dart';
import 'package:konstudy/routes/app_routes.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // 🔹 Headline / App-Name
              const Text(
                "KonStudy", // App-Name hier anpassen
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
                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name darf nicht leer sein';
                        }
                        return null;
                      },
                    ),

                    // E-Mail
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
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

                    // Passwort
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
                              final scaffoldMessenger = ScaffoldMessenger.of(
                                context,
                              );

                              try {
                                // Registrierung, ebenfalls Future<void> und Exception bei Fehler
                                await ref
                                    .read(authControllerProvider.notifier)
                                    .signUp(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                      _nameController.text.trim(),
                                    );

                                // Wenn kein Fehler: Zur HomePage weiterleiten
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.home,
                                );
                              } catch (e) {
                                // Fehler anzeigen
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Fehler: ${e.toString()}'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text("Registrieren"),
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
