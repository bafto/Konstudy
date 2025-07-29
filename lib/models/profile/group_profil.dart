import 'package:konstudy/models/profile/user_profil.dart';

class GroupProfil {
  final String name;
  final String? description;
  final String? imageUrl;
  final List<UserProfil> members;
  final bool isCurrentUserAdmin;

  GroupProfil({
    required this.name,
    this.description,
    this.imageUrl,
    required this.members,
    required this.isCurrentUserAdmin,
  });
}
