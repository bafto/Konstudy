
class UserProfil{
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
}