import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/provider/auth_provider.dart';

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
      body: Stack(
        children: [
          // 🔹 Hintergrundbild
          Positioned.fill(
            child: Image.asset(
              'assets/images/Imperia.png', // <-- Stelle sicher, dass dein Bild hier liegt!
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 Dunkler Overlay für bessere Lesbarkeit
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

          // 🔹 Scrollbarer, zentrierter Inhalt
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
                        _buildTextField(
                          controller: _nameController,
                          label: "Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name darf nicht leer sein';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _emailController,
                          label: "E-Mail",
                          keyboardType: TextInputType.emailAddress,
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
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _passwordController,
                          label: "Passwort",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Mindestens 6 Zeichen';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

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
                                        .signUp(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                          _nameController.text.trim(),
                                        );

                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Bitte bestätige deine E-Mail-Adresse über den Link, den wir dir geschickt haben.',
                                        ),
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                  } catch (e) {
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Fehler: ${e.toString()}',
                                        ),
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
        ],
      ),
    );
  }

  // 🔧 Wiederverwendbare Methode für Felder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.85),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }
}
