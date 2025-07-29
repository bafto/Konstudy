import 'package:konstudy/models/profile/group_profil.dart';
import 'package:konstudy/services/profile/group/igroup_profil_service.dart';

import '../../auth/iauth_service.dart';
import '../../persistence/igroups_repository.dart';

class GroupProfilService implements IGroupProfilService {
  final IGroupRepository _repository;
  final IAuthService _authService;

  GroupProfilService(this._repository, this._authService);

  @override
  Future<GroupProfil> fetchGroupProfile(String groupId) async {
    final currentUserId = await _authService.getCurrentUserId();
    if (currentUserId == null) {
      throw Exception('Kein eingeloggter Benutzer gefunden');
    }
    return _repository.fetchGroupProfile(groupId, currentUserId);
  }
}

