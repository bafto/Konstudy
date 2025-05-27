class Note {
  final String id;
  final String groupId;
  final String title;
  final String content;

  Note({required this.id, required this.groupId, required this.title, required this.content});

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'] as String,
    groupId: map['group_id'] as String,
    title: map['title'] as String,
    content: map['content'] as String,
  );

  Map<String, dynamic> toMap() => {
    'group_id': groupId,
    'title': title,
    'content': content,
  };
}