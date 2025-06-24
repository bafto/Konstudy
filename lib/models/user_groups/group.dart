import 'package:konstudy/models/user_groups/group_member.dart';

class Group {
  final String id;
  final String name;
  final String? description;
  final List<GroupMember> members;

  Group({
    required this.id,
    required this.name,
    this.description,
    required this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    final members =
        (json['group_members'] as List)
            .map((m) => GroupMember.fromJson(m as Map<String, dynamic>))
            .toList();

    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?, // 👈 hier kann null stehen
      members: members,
    );
  }
}
