import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:konstudy/models/editor/note.dart';
import 'package:konstudy/controllers/editor/note_controller_provider.dart';

class NoteEditorPage extends ConsumerStatefulWidget {
  final String? noteId;
  final String groupId;

  const NoteEditorPage({super.key, required this.groupId, this.noteId});

  @override
  ConsumerState<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends ConsumerState<NoteEditorPage> {
  final _titleController = TextEditingController();
  late QuillController _quillController;
  bool _saving = false;
  bool _isLoading = true;
  Note? _note;

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
      final doc = Document.fromJson(docJson as List<dynamic>);
      _quillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = QuillController.basic();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    setState(() => _saving = true);
    final controller = ref.read(noteControllerProvider);

    final contentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );

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
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_note == null ? 'Neue Notiz' : 'Notiz bearbeiten'),
        actions: [
          IconButton(
            icon:
                _saving
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
              focusNode: FocusNode(),
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            const SizedBox(height: 12),
            QuillSimpleToolbar(controller: _quillController),
            const SizedBox(height: 8),
            Expanded(
              child: QuillEditor(
                controller: _quillController,
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                config: new QuillEditorConfig(autoFocus: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
