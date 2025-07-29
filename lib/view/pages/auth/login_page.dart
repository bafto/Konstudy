import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/auth/auth_controller_provider.dart';
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
      body: Stack(
        children: [
          // 🔹 Hintergrundbild über ganze Fläche
          Positioned.fill(
            child: Image.asset('assets/images/Imperia.png', fit: BoxFit.cover),
          ),

          // 🔹 Optionaler dunkler Overlay für bessere Lesbarkeit
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

          // 🔹 Inhalt: mittig und scrollbar
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "KonStudy",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 6.0,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.black,
                          ), // Eingabetext
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "E-Mail",
                            labelStyle: const TextStyle(color: Colors.black87),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.85),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black26,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black87,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "Passwort",
                            labelStyle: const TextStyle(color: Colors.black87),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.85),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black26,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black87,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        state.isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  try {
                                    await ref
                                        .read(authControllerProvider.notifier)
                                        .login(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        );

                                    if (context.mounted) {
                                      HomeScreenRoute().go(context);
                                    }
                                  } catch (e) {
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(content: Text('Fehler: $e')),
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
        ],
      ),
    );
  }
}
