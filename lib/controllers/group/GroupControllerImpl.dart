import 'package:konstudy/controllers/group/IGroupController.dart';
import 'package:konstudy/services/group/IGroupService.dart';
import 'package:konstudy/models/group/Note.dart';
import 'package:konstudy/models/group/Median.dart';

class GroupControllerImpl implements IGroupController{
  final IGroupService _service;

  GroupControllerImpl(this._service);

  List<Note> _notes = [];
  List<Median> _medians = [];

  @override
  List<Note> get notes => _notes;

  @override
  List<Median> get medians => _medians;

  @override
  Future<void> loadNotes() async {
    _notes = await _service.fetchNotes();
  }

  @override
  Future<void> loadMedians() async{
    _medians = await _service.fetchMedian();
  }
}