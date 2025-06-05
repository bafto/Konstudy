import 'package:flutter/material.dart';

class BlackBoardEntryPage extends StatefulWidget {
  final String entryId;

  const BlackBoardEntryPage({super.key, required this.entryId});

  @override
  State<BlackBoardEntryPage> createState() => _BlackBoardEntryPageState();
}

class _BlackBoardEntryPageState extends State<BlackBoardEntryPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Test'));
  }
}
