import 'package:flutter/foundation.dart';
import 'package:konstudy/controllers/user_groups/iuser_groups_controller.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserGroupsControllerImpl extends ChangeNotifier
    implements IUserGroupsController {
  final IUserGroupsService _service;

  UserGroupsControllerImpl(this._service);

  @override
  Future<List<Group>> getGroups() => _service.fetchGroups();

  @override
  Future<Group> addGroup(Group g) async {
    final user = Supabase.instance.client.auth.currentUser!;
    return _service.addGroup(
      Group(
        id: g.id,
        name: g.name,
        description: g.description,
        memberNames: [user.email!],
      ),
    );
    notifyListeners();
  }
}
