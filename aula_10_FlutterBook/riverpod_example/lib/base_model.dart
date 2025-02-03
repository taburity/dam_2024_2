class BaseModel {

  int stackIndex;
  List entityList;
  dynamic entityBeingEdited;
  String? chosenDate;

  BaseModel({
    this.stackIndex = 0,
    this.entityList = const [],
    this.entityBeingEdited,
    this.chosenDate,
  });

  BaseModel copyWith({
    int? stackIndex,
    List<dynamic>? entityList,
    dynamic entityBeingEdited,
    String? chosenDate,
  }) {
    return BaseModel(
      stackIndex: stackIndex ?? this.stackIndex,
      entityList: entityList ?? this.entityList,
      entityBeingEdited: entityBeingEdited ?? this.entityBeingEdited,
      chosenDate: chosenDate ?? this.chosenDate,
    );
  }
}


