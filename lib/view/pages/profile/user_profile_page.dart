import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/controllers/auth/auth_controller_provider.dart';
import 'package:konstudy/controllers/profile/user/user_profil_controller_provider.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/routes/app_routes.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  final String? userId; // Wenn null, dann aktueller User

  const UserProfilePage({super.key, this.userId});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  late Future<UserProfil> _userFuture;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(userProfilControllerProvider);
    // Hier userId mitgeben, wenn vorhanden
    _userFuture = controller.fetchUserProfile(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(child: Text("UserProfil")),
        actions: [
          FutureBuilder<UserProfil>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final user = snapshot.data!;
              return PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'Bearbeiten') {
                    debugPrint("Profil bearbeiten");
                    // hier navigieren oder bearbeiten
                  } else if (value == 'Ausloggen') {
                    debugPrint("User loggt sich aus");
                    final authController = ref.read(authControllerProvider.notifier);
                    try {
                      await authController.logout();
                      if (context.mounted) {
                        AuthPageRoute().go(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Fehler beim Ausloggen: $e")),
                      );
                    }
                  } else if (value == 'Löschen') {
                    debugPrint("Account Löschen");
                  } else if (value == 'Nachricht senden') {
                    debugPrint("Nachricht an ${user.name} senden");
                  } else if (value == 'Profil melden') {
                    debugPrint("Profil melden");
                  }
                },
                itemBuilder: (BuildContext context) {
                  if (user.isCurrentUser) {
                    return ['Bearbeiten', 'Ausloggen', 'Löschen'].map((choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  } else {
                    return ['Nachricht senden', 'Profil melden'].map((choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  }
                },
              );
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
                user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
            child:
                user.profileImageUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
          ),
          const SizedBox(height: 20),
          Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(user.email, style: Theme.of(context).textTheme.bodyLarge),
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
