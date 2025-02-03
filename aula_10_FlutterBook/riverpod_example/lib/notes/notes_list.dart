import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "note.dart";
import "notes_dbworker.dart";
import "notes_model_provider.dart";


class NotesList extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("## NotesList.build()");

    final model = ref.watch(notesModelNotifierProvider);
    final notifier = ref.read(notesModelNotifierProvider.notifier);

    return Scaffold(
        floatingActionButton : FloatingActionButton(
          child : Icon(Icons.add, color : Colors.white),
          onPressed : () async {
            model.entityBeingEdited = Note(
              title: '',
              content: '',
              color: ''
            );
            notifier.setColor('');
            notifier.setStackIndex(1);
          }
        ),
        body : ListView.builder(
              itemCount : model.entityList.length,
              itemBuilder : (BuildContext inBuildContext, int inIndex) {
                Note note = model.entityList[inIndex];
                Color color = Colors.white;
                switch (note.color) {
                  case "red" : color = Colors.red; break;
                  case "green" : color = Colors.green; break;
                  case "blue" : color = Colors.blue; break;
                  case "yellow" : color = Colors.yellow; break;
                  case "grey" : color = Colors.grey; break;
                  case "purple" : color = Colors.purple; break;
                }
                return Container(
                  padding : EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child : Slidable(
                    key: ValueKey(note.id),
                    endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                          onPressed: (context) => _deleteNote(inBuildContext, note, notifier),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          ),
                        ],
                    ),
                    child : Card(
                      elevation : 8,
                      color : color,
                      child : ListTile(
                        title : Text("${note.title}"),
                        subtitle : Text("${note.content}"),
                        onTap : () async {
                            model.entityBeingEdited = await NotesDBWorker.db.get(note.id!);
                            notifier.setColor(model.entityBeingEdited.color);
                            notifier.setStackIndex(1);
                        },
                      ),
                    ),
                  ),
                );
              },
            )
        );
  }

  Future _deleteNote(BuildContext inContext, Note inNote, NotesModelNotifier notifier) async {
    print("## NotestList._deleteNote(): inNote = $inNote");
    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete Note"),
          content : Text("Are you sure you want to delete ${inNote.title}?"),
          actions : [
            ElevatedButton(child : Text("Cancel"),
              onPressed: () {
                Navigator.of(inAlertContext).pop();
              }
            ),
            ElevatedButton(child : Text("Delete"),
              onPressed : () async {
                await NotesDBWorker.db.delete(inNote.id!);
                Navigator.of(inAlertContext).pop();
                ScaffoldMessenger.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("Note deleted")
                  )
                );
                notifier.loadData("notes", NotesDBWorker.db);
              }
            )]);});
  }

}
