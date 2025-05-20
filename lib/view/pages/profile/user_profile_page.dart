import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/controllers/auth/auth_controller_provider.dart';

import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/controllers/profile/user_profil_controller_provider.dart';
import 'package:konstudy/routes/routes_paths.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  late Future<UserProfil> _userFuture;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(userProfilControllerProvider);
    _userFuture = controller.fetchUserProfil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Center(child: Text("UserProfil")),
        actions: [
          // Dropdown-Menü in der AppBar
          PopupMenuButton<String>(
            onSelected: (value) async {
              // Aktionen basierend auf der Auswahl durchführen
              if (value == 'Bearbeiten') {
                // Logik zum Bearbeiten des Events
                debugPrint("Profil bearbeiten");
              } else if (value == 'Ausloggen') {
                // Event Ausloggen
                debugPrint("User logt sich aus");
                final authController = ref.read(authControllerProvider.notifier);

                try{
                  await authController.logout();
                  if(context.mounted){
                    context.go(RoutesPaths.auth);
                  }
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Fehler beim Ausloggen: $e")),
                  );
                }

              }else if (value == 'Löschen'){
                //Event Löschen
                //fenster muss nach Löschen sich selber schließen
                debugPrint("Account Löschen");
              }
            },
            itemBuilder: (BuildContext context) {
              return ['Bearbeiten', 'Ausloggen', 'Löschen'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder<UserProfil>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }

          final user = snapshot.data!;
          return _UserProfileContent(user: user);
        },
      ),
    );
  }
}

class _UserProfileContent extends StatelessWidget {
  final UserProfil user;

  const _UserProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
            user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null,
            child: user.profileImageUrl == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          const SizedBox(height: 20),
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Beschreibung",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
            ),
            child: Text(
              user.description?.isNotEmpty == true
                  ? user.description!
                  : 'Keine Beschreibung vorhanden.',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}


