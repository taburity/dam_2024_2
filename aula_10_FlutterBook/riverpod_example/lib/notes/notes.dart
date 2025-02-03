import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "notes_list.dart";
import "notes_entry.dart";
import "notes_model_provider.dart";

class Notes extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesModel = ref.watch(notesModelNotifierProvider);

    return IndexedStack(
        index: notesModel.stackIndex,
        children: [
          NotesList(),
          NotesEntry()
        ]
    );
  }
}
