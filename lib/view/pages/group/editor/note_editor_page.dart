import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:go_router/go_router.dart';

import 'package:konstudy/models/group/editor/note.dart';
import 'package:konstudy/controllers/editor/note_controller_provider.dart';

class NoteEditorPage extends ConsumerStatefulWidget {
  final String? noteId;
  final String groupId;

  const NoteEditorPage({
    super.key,
    required this.groupId,
    this.noteId,
  });

  @override
  ConsumerState<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends ConsumerState<NoteEditorPage> {
  final _titleController = TextEditingController();
  EditorState? _editorState;
  bool _saving = false;
  bool _isLoading = true;
  Note? _note;

  final FocusNode _editorFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadOrInitNote();
  }

  Future<void> _loadOrInitNote() async {
    final controller = ref.read(noteControllerProvider);

    if (widget.noteId != null) {
      _note = await controller.getNoteById(widget.noteId!);
      _titleController.text = _note!.title;

      final docJson = jsonDecode(_note!.content);
      _editorState = EditorState(document: Document.fromJson(docJson as Map<String, dynamic>));
    } else {
      _editorState = EditorState.blank(withInitialText: true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    setState(() => _saving = true);
    final controller = ref.read(noteControllerProvider);

    final contentJson = jsonEncode(_editorState!.document.toJson());

    await controller.saveNotes(
      id: _note?.id,
      groupId: widget.groupId,
      title: _titleController.text,
      contentJson: contentJson,
      isNew: _note == null,
    );

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _editorState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_note == null ? 'Neue Notiz' : 'Notiz bearbeiten'),
        actions: [
          IconButton(
            icon: _saving
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.save),
            onPressed: _saving ? null : _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: AppFlowyEditor(
                editorState: _editorState!,
                focusNode: _editorFocusNode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

