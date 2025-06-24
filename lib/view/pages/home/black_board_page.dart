import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/controllers/black_board/black_board_controller_provider.dart';
import 'package:konstudy/controllers/user_groups/user_groups_controller_provider.dart';
import 'package:konstudy/models/black_board/black_board_entry.dart';
import 'package:konstudy/routes/app_routes.dart';
import 'package:konstudy/view/widgets/cards/black_board_entry_card.dart';

class BlackBoardPage extends ConsumerStatefulWidget {
  const BlackBoardPage({super.key});

  @override
  ConsumerState<BlackBoardPage> createState() => _BlackBoardPageState();
}

class _BlackBoardPageState extends ConsumerState<BlackBoardPage> {
  Widget _buildGroupCard(final BlackBoardEntry entry) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      child: BlackBoardEntryCard(entry: entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(blackBoardControllerProvider);
    final groupsController = ref.watch(userGroupsControllerProvider);

    return Scaffold(
      body: FutureBuilder(
        future: controller.getEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Keine Einträge'));
          }

          return ListView(
            children: snapshot.data?.map(_buildGroupCard).toList() ?? [],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CreateBlackBoardEntryPageRoute().push<void>(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
