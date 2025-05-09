class Median{
  final int id;
  final String fileName;

  Median({required this.id, required this.fileName});

  factory Median.fromJson(Map<String, dynamic> json) => Median(
      id: json['id'] as int,
      fileName: json['filename'] as String,
  );
}