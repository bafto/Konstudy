class Group {
  final int id;
  final String name;
  final String description;
  final List<String> memberNames; // TODO: make this a User ref

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.memberNames,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    memberNames: json['memberNames'] as List<String>,
  );
}
