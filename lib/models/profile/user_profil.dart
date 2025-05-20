
class UserProfil{
  final String name;
  final String email;
  final String? description;
  final String? profileImageUrl;

  UserProfil({
    required this.name,
    required this.email,
    this.description,
    this.profileImageUrl,
  });
}