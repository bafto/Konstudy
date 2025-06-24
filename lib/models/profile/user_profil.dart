class UserProfil {
  final String id;
  final String name;
  final String email;
  final String? description;
  final String? profileImageUrl;
  final bool isCurrentUser;

  UserProfil({
    required this.id,
    required this.name,
    required this.email,
    this.description,
    this.profileImageUrl,
    this.isCurrentUser = false,
  });

  factory UserProfil.fromJson(Map<String, dynamic> json) {
    return UserProfil(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      description: json['description'] as String?,
      profileImageUrl: json['avatar_url'] as String?,
    );
  }
}
