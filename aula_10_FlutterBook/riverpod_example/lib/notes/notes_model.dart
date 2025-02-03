import "../base_model.dart";

class NotesModel extends BaseModel {
  final String? color;

  NotesModel({
    super.stackIndex,
    super.entityList,
    super.entityBeingEdited,
    super.chosenDate,
    this.color,
  });

  @override
  NotesModel copyWith({
    int? stackIndex,
    List<dynamic>? entityList,
    dynamic entityBeingEdited,
    String? chosenDate,
    String? color,
  }) {
    return NotesModel(
      stackIndex: stackIndex ?? this.stackIndex,
      entityList: entityList ?? this.entityList,
      entityBeingEdited: entityBeingEdited ?? this.entityBeingEdited,
      chosenDate: chosenDate ?? this.chosenDate,
      color: color ?? this.color,
    );
  }
}
