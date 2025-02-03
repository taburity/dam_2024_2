import "../base_model.dart";


class ContactsModel extends BaseModel {

  ContactsModel({
    super.stackIndex,
    super.entityList,
    super.entityBeingEdited,
    super.chosenDate,
  });

  @override
  ContactsModel copyWith({
    int? stackIndex,
    List<dynamic>? entityList,
    dynamic entityBeingEdited,
    String? chosenDate,
  }) {
    return ContactsModel(
      stackIndex: stackIndex ?? this.stackIndex,
      entityList: entityList ?? this.entityList,
      entityBeingEdited: entityBeingEdited ?? this.entityBeingEdited,
      chosenDate: chosenDate ?? this.chosenDate,
    );
  }

}
