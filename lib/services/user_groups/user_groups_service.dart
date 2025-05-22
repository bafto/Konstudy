import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';

class UserGroupsService implements IUserGroupsService {
  final _groups = [
    Group(
      id: 0,
      name: "Embedded Systems",
      description: "Embedded Systems",
      memberNames: ["Hendrik", "Leon"],
    ),
    Group(
      id: 1,
      name: "Mobile Anwendungen",
      description: "Mobile Anwendungen",
      memberNames: ["Hendrik", "Konstantin"],
    ),
  ];

  @override
  Future<List<Group>> fetchGroups() async {
    await Future.delayed(
      Duration(seconds: 1),
    ); //simulation eines Netzwerkaufruf
    return List.unmodifiable(_groups);
  }

  @override
  Future<Group> addGroup(Group g) async {
    _groups.add(g);
    return _groups.last;
  }
}
