import 'package:konstudy/models/profile/user_profil.dart';
import 'package:konstudy/services/profile/user/iuser_profil_service.dart';

import '../../auth/iauth_service.dart';
import '../../persistence/iusers_repository.dart';

class UserProfilService implements IUserProfilService {
  final IUserRepository _userRepository;
  final IAuthService _authService; // Abstraktion für Auth (für currentUser etc)

  UserProfilService(this._userRepository, this._authService);

  @override
  Future<UserProfil> fetchUserProfile({String? userId}) async {
    final currentUserId = _authService.getCurrentUserId();
    if (currentUserId == null) {
      throw Exception("Nicht eingeloggt");
    }

    final effectiveUserId = userId ?? currentUserId;


    final userProfil = await _userRepository.fetchUserProfil(effectiveUserId);

    return UserProfil(
      id: userProfil.id,
      name: userProfil.name,
      email: userProfil.email,
      description: userProfil.description,
      profileImageUrl: userProfil.profileImageUrl,
      isCurrentUser: effectiveUserId == currentUserId,
    );
  }

  @override
  Future<bool> deleteOwnAccount() async {
    final jwt = _authService.getJwtToken();
    final success = await _userRepository.deleteOwnAccount(jwt);
    if (success) {
      await _authService.signOut();
    }
    return success;
  }

  @override
  Future<void> updateUserProfil({
    required String userId,
    String? name,
    String? description,
    String? profileImageUrl,
  }) async {
    await _userRepository.updateUserProfil(
      userId: userId,
      name: name,
      description: description,
      profileImageUrl: profileImageUrl,
    );
  }
}

