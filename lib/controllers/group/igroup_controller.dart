import 'package:konstudy/models/group/media.dart';

abstract class IGroupController {
  Future<List<Media>> getMedia();
}
