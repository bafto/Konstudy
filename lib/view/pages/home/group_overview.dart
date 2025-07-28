import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/auth/auth_controller_provider.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_provider.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/view/widgets/cards/group_card.dart';

class Groupoverview extends ConsumerStatefulWidget {
  const Groupoverview({super.key});

  @override
  ConsumerState<Groupoverview> createState() => _GroupoverviewState();
}

class _GroupoverviewState extends ConsumerState<Groupoverview> {
  Widget _buildGroupCard(final Group group) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      child: GroupCard(
        groupId: group.id,
        name: group.name,
        description: group.description ?? '',
        members: List.generate(
          group.members.length,
          (w) => Icon(Icons.account_circle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupsController = ref.watch(userGroupsControllerProvider);
    final _ = ref.watch(
      authControllerProvider.notifier,
    ); // to refresh groups when a user logs out and logs back in as another user

    return Scaffold(
      body: FutureBuilder(
        future: groupsController.getGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.isEmpty ?? true) {
            return const Center(
              child: Text("Keine Gruppen gefunden, bist du online?"),
            );
          }

          return ListView(
            children: snapshot.data?.map(_buildGroupCard).toList() ?? [],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CreateGroupPageRoute().push<void>(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
