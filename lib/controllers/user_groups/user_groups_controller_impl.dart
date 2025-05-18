import 'package:konstudy/controllers/user_groups/iuser_groups_controller.dart';
import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';

class UserGroupsControllerImpl implements IUserGroupsController {
  final IUserGroupsService _service;

  UserGroupsControllerImpl(this._service);

  List<Group> _groups = [];

  @override
  List<Group> get groups => _groups;

  @override
  Future<void> loadGroups() async {
    _groups = await _service.fetchGroups();
  }
}
