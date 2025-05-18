import 'package:konstudy/models/user_groups/group.dart';
import 'package:konstudy/services/user_groups/iuser_groups_service.dart';

class UserGroupsService implements IUserGroupsService {
  @override
  Future<List<Group>> fetchGroups() async {
    await Future.delayed(
      Duration(seconds: 1),
    ); //simulation eines Netzwerkaufruf
    return [
      Group(
        id: 1,
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
  }
}
