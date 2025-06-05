class BlackBoardEntry {
  final String id;
  final String creatorId;
  final String title;
  final String description;

  BlackBoardEntry({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
  });

  factory BlackBoardEntry.fromJson(Map<String, dynamic> json) =>
      BlackBoardEntry(
        id: json['id'] as String,
        creatorId: json['creatorId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
      );
}
