class BlackBoardEntry {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final String groupId;
  final List<String> hashTags;

  BlackBoardEntry({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.groupId,
    required this.hashTags,
  });

  factory BlackBoardEntry.fromJson(Map<String, dynamic> json) =>
      BlackBoardEntry(
        id: json['id'] as String,
        creatorId: json['creatorId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        groupId: json['groupId'] as String,
        hashTags:
            ((json['hashTags'] ?? <String>[]) as List<dynamic>)
                .whereType<String>()
                .toList(),
      );
}
