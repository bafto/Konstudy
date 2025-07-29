class Media {
  final String fileName;
  final String filePath;

  Media({required this.fileName, required this.filePath});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      fileName: json['name'] as String,
      filePath: json['name'] as String,
    );
  }
}
