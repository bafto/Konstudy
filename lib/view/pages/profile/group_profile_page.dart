import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:konstudy/provider/auth_provider.dart';
import 'package:konstudy/provider/black_board_provider.dart';
import 'package:konstudy/provider/group_profil_provider.dart';
import 'package:konstudy/provider/user_groups_provider.dart';
import 'package:konstudy/models/profile/group_profil.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/view/widgets/cards/user_card.dart';

class GroupProfilePage extends ConsumerStatefulWidget {
  final String groupId;

  const GroupProfilePage({super.key, required this.groupId});

  @override
  ConsumerState<GroupProfilePage> createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends ConsumerState<GroupProfilePage> {
  late Future<GroupProfil> _groupFuture;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(groupProfilControllerProvider);
    _groupFuture = controller.fetchGroupProfile(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    final groupsController = ref.watch(userGroupsControllerProvider);
    final _ = ref.watch(
      blackBoardControllerProvider,
    ); // to refetch the black board entries when group membership changes
    final userId = ref.watch(authControllerProvider.notifier).currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gruppenprofil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          FutureBuilder<GroupProfil>(
            future: _groupFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(); // Noch keine Daten, kein Menü
              }
              final group = snapshot.data!;
              final isAdmin = group.isCurrentUserAdmin;

              return PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'Bearbeiten') {
                    debugPrint("Gruppe bearbeiten");
                    // TODO: Edit-Funktionalität hier ergänzen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feature wird noch eingebaut'),
                      ),
                    );
                  } else if (value == 'Löschen') {
                    debugPrint("Gruppe löschen");
                    groupsController.deleteGroup(widget.groupId);
                    HomeScreenRoute().go(context);
                  } else if (value == 'Verlassen') {
                    debugPrint("Gruppe verlassen");
                    groupsController.removeUserFromGroup(
                      userId,
                      widget.groupId,
                    );
                  }
                },
                itemBuilder: (context) {
                  if (isAdmin) {
                    return ['Bearbeiten', 'Löschen']
                        .map(
                          (choice) => PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          ),
                        )
                        .toList();
                  } else {
                    return ['Verlassen']
                        .map(
                          (choice) => PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          ),
                        )
                        .toList();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<GroupProfil>(
        future: _groupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }
          final group = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(group),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Mitglieder',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 8),
                ...group.members.map<Widget>(
                  (user) => UserCard(
                    name: user.name,
                    email: user.email,
                    imageUrl: user.profileImageUrl,
                    onTap: () {
                      UserProfilePageRoute(userId: user.id).push<void>(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(GroupProfil group) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                group.imageUrl != null && group.imageUrl!.isNotEmpty
                    ? NetworkImage(group.imageUrl!)
                    : null,
            child:
                group.imageUrl == null || group.imageUrl!.isEmpty
                    ? const Icon(Icons.group, size: 40)
                    : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  group.description?.isNotEmpty == true
                      ? group.description!
                      : 'Keine Beschreibung vorhanden.',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
