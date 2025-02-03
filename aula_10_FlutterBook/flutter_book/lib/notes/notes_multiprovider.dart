import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "notes_dbworker.dart";
import "notes_list.dart";
import "notes_entry.dart";
import "notes_model.dart";

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesModel>(
          create: (context) {
            NotesModel model = NotesModel(color: '');
            model.loadData("notes", NotesDBWorker.db);
            return model;
          },
        ),
        ChangeNotifierProvider<AnotherModel>(
          create: (context) => AnotherModel(),
        ),
      ],
      child: Consumer2<NotesModel, AnotherModel>(
        builder: (context, notesModel, anotherModel, child) {
          return IndexedStack(
            index: notesModel.stackIndex,
            children: [
              NotesList(),
              NotesEntry(),
            ],
          );},),);
  }
}

class AnotherModel extends ChangeNotifier { }
