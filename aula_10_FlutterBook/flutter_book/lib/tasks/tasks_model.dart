import "../base_model.dart";


///Uma classe que representa uma tarefa
class Task {

  int? id;
  String description;
  String? dueDate;
  String completed;

  Task({
    this.id,
    required this.description,
    this.dueDate,
    this.completed = "false"
  });

  String toString() {
    return "{ id=$id, description=$description, dueDate=$dueDate, completed=$completed }";
  }

}


/// The model backing this entity type's views.
class TasksModel extends BaseModel {}

