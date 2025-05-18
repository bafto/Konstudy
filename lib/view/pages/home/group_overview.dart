import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_provider.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/view/widgets/cards/group_card.dart';

class Groupoverview extends ConsumerStatefulWidget {
  const Groupoverview({super.key});

  @override
  ConsumerState<Groupoverview> createState() => _GroupoverviewState();
}

class _GroupoverviewState extends ConsumerState<Groupoverview> {
  @override
  void initState() {
    super.initState();
    Future.microtask(ref.read(userGroupsControllerProvider).loadGroups);
  }

  Widget _buildGroupCard(final Group group) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      child: GroupCard(
        name: group.name,
        description: group.description,
        members: List.generate(
          group.memberNames.length,
          (w) => Icon(Icons.account_circle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupsController = ref.watch(userGroupsControllerProvider);
    return Scaffold(
      body: ListView(
        children: groupsController.groups.map(_buildGroupCard).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => debugPrint("new group"),
      ),
    );
  }
}
