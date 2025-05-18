class Media {
  final int id;
  final String fileName;

  Media({required this.id, required this.fileName});

  factory Media.fromJson(Map<String, dynamic> json) =>
      Media(id: json['id'] as int, fileName: json['filename'] as String);
}
