class GroupMember {
  final String userId;
  final String groupId;

  GroupMember({
    required this.userId,
    required this.groupId,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userId: json['user_id'] as String,
      groupId: json['group_id'] as String,
    );
  }
}