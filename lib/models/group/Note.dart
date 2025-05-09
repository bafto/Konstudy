class Note{
  final int id;
  final String name;
  final String description;

  Note({required this.id, required this.name, required this.description});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
  );
}