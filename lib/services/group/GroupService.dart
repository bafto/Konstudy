import 'package:konstudy/services/group/IGroupService.dart';
import 'package:konstudy/models/group/Note.dart';
import 'package:konstudy/models/group/Median.dart';



class GroupService implements IGroupService{
  @override
  Future<List<Note>> fetchNotes() async {
    await Future.delayed(Duration(seconds:  1)); //simulation eines Netzwerkaufruf
    return[
      Note(id: 1, name:'Linksammlung', description: 'Ansammlung von Links'),
      Note(id: 2, name:'Mitschrieb', description: 'Notizen von der Vorlesung'),
      Note(id: 3, name:'Aufgabenteilung', description: 'Aufgaben aufteilung'),
    ];
  }
  @override
  Future<List<Median>> fetchMedian() async{
    await Future.delayed(Duration(seconds: 1)); //simulation eines Netzwerkaufruf
    return[
      Median(id: 1, fileName: "Zusammenfassung.pdf"),
      Median(id: 2, fileName: "Tafelbild.png"),
    ];
  }
}