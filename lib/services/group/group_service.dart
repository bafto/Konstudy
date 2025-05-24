import 'package:konstudy/models/group/media.dart';
import 'package:konstudy/services/group/igroup_service.dart';

class GroupService implements IGroupService {


  @override
  Future<List<Media>> fetchMedia() async {
    await Future.delayed(
      Duration(seconds: 1),
    ); //simulation eines Netzwerkaufruf
    return [
      Media(id: 1, fileName: "Zusammenfassung.pdf"),
      Media(id: 2, fileName: "Tafelbild.png"),
    ];
  }
}
