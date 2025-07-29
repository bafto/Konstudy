import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/provider/user_profil_provider.dart';

class UserProfilEditPage extends ConsumerStatefulWidget {
  const UserProfilEditPage({super.key});

  @override
  ConsumerState<UserProfilEditPage> createState() => _UserProfilEditPageState();
}

class _UserProfilEditPageState extends ConsumerState<UserProfilEditPage> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  // Variable um das Profil zu speichern, sobald geladen
  UserProfil? profil;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadUserProfil();
  }

  Future<void> _loadUserProfil() async {
    try {
      final controller = ref.read(userProfilControllerProvider);
      final loadedProfil = await controller.fetchUserProfile();

      setState(() {
        profil = loadedProfil;
        nameController = TextEditingController(text: profil?.name);
        descriptionController = TextEditingController(
          text: profil?.description,
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _save() async {
    if (profil == null) return;

    final controller = ref.read(userProfilControllerProvider);
    try {
      await controller.updateUserProfil(
        userId: profil!.id,
        name: nameController.text,
        description: descriptionController.text,
      );
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text('Fehler beim Laden: $error')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil bearbeiten')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Profilbild ändern wird bald verfügbar sein.',
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage:
                    profil!.profileImageUrl != null
                        ? NetworkImage(profil!.profileImageUrl!)
                        : null,
                child:
                    profil!.profileImageUrl == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Beschreibung'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Speichern')),
          ],
        ),
      ),
    );
  }
}
