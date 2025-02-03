import "../base_model.dart";


class TasksModel extends BaseModel {

  TasksModel({
    super.stackIndex,
    super.entityList,
    super.entityBeingEdited,
    super.chosenDate,
  });

  @override
  TasksModel copyWith({
    int? stackIndex,
    List<dynamic>? entityList,
    dynamic entityBeingEdited,
    String? chosenDate,
  }) {
    return TasksModel(
      stackIndex: stackIndex ?? this.stackIndex,
      entityList: entityList ?? this.entityList,
      entityBeingEdited: entityBeingEdited ?? this.entityBeingEdited,
      chosenDate: chosenDate ?? this.chosenDate,
    );
  }

}

