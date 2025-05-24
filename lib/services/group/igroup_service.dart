import 'package:konstudy/models/group/media.dart';

abstract class IGroupService {
  Future<List<Media>> fetchMedia();
}
