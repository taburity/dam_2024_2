import "../base_model.dart";


class AppointmentsModel extends BaseModel {
  String apptTime;

  AppointmentsModel({
    super.stackIndex,
    super.entityList,
    super.entityBeingEdited,
    super.chosenDate,
    required this.apptTime,
  });

  @override
  AppointmentsModel copyWith({
    int? stackIndex,
    List<dynamic>? entityList,
    dynamic entityBeingEdited,
    String? chosenDate,
    String? apptTime,
  }) {
    return AppointmentsModel(
      stackIndex: stackIndex ?? this.stackIndex,
      entityList: entityList ?? this.entityList,
      entityBeingEdited: entityBeingEdited ?? this.entityBeingEdited,
      chosenDate: chosenDate ?? this.chosenDate,
      apptTime: apptTime ?? this.apptTime,
    );
  }
}