import 'package:flutter/material.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('E-Mail Verifizierung')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 24),
            Text(
              'Bitte bestätige deine E-Mail-Adresse',
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Wir haben eine E-Mail an die Adresse gesendet die du angegeben hast.\n'
              'Klicke auf den Link in der Mail, um deinen Account zu aktivieren.',
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // z.B. zurück zur Login-Seite
              },
              child: const Text('Zurück zum Login'),
            ),
          ],
        ),
      ),
    );
  }
}
