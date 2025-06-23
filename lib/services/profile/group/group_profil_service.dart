import 'package:konstudy/models/profile/group_profil.dart';
import 'package:konstudy/models/profile/user_profil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:konstudy/services/profile/group/igroup_profil_service.dart';

class GroupProfilService implements IGroupProfilService{
  final supabase = Supabase.instance.client;

  @override
  Future<GroupProfil> fetchGroupProfile(String groupId) async {
    final currentUserId = supabase.auth.currentUser?.id ?? '';

    final response = await supabase
        .from('groups')
        .select('''
          name,
          description,
          profile_image_url,
          group_members (
            users (
              id,
              name,
              email,
              description,
              avatar_url
            )
          )
        ''')
        .eq('id', groupId)
        .single();

    // Mitglieder extrahieren
    final memberData = response['group_members'] as List<dynamic>? ?? [];

    final members = memberData.map((entry) {
      final user = entry['users'];
      return UserProfil(
        id: user['id'] as String,
        name: user['name'] as String,
        email: user['email'] as String,
        description: user['description'] as String?,
        profileImageUrl: user['image_url'] as String?,
      );
    }).toList();
    
    final adminData = await supabase
        .from('group_members')
        .select('is_admin')
        .eq('group_id', groupId)
        .eq('user_id', currentUserId)
        .single();

    final isAdmin = adminData != null ? adminData['is_admin'] as bool : false;

    return GroupProfil(
      name: response['name'] as String,
      description: response['description'] as String?,
      imageUrl: response['image_url'] as String?,
      members: members,
      isCurrentUserAdmin: isAdmin,
    );

  }

}