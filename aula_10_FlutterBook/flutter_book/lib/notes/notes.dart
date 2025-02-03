import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "notes_dbworker.dart";
import "notes_list.dart";
import "notes_entry.dart";
import "notes_model.dart";


/// Tela de notas
class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<NotesModel>(
        create: (context) {
          NotesModel model = NotesModel(color: '');
          model.loadData("notes", NotesDBWorker.db);
          return model;
        },

        child: Consumer<NotesModel>(
            builder: (context, inModel, child) {
              return IndexedStack(
                  index: inModel.stackIndex,
                  children: [
                    NotesList(),
                    NotesEntry()
                  ]
              );
            }
        )
    );
  }
}
