import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'notes_dbworker.dart';
import 'notes_model.dart';
import 'note.dart';
import '../base_model_provider.dart';

part 'notes_model_provider.g.dart';

@riverpod
class NotesModelNotifier extends BaseModelNotifier<NotesModel> {
  NotesModelNotifier() : super(NotesModel());

  @override
  NotesModel build(){
    var model = NotesModel(color:'');
    loadData("notes", NotesDBWorker.db);
    return model;
  }

  void setColor(String color) {
    state = state.copyWith(color: color);
  }

  void editNote(Note note) {
    state = state.copyWith(entityBeingEdited: note);
  }

}
