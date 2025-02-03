import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "tasks_model_provider.dart";
import "task.dart";
import "tasks_dbworker.dart";
import "tasks_model.dart";


/// The Tasks List sub-screen.
class TasksList extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("## TasksList.build()");

    final model = ref.watch(tasksModelNotifierProvider);
    final notifier = ref.read(tasksModelNotifierProvider.notifier);

    return Scaffold(
        floatingActionButton : FloatingActionButton(
          child : Icon(Icons.add, color : Colors.white),
          onPressed : () async {
            model.entityBeingEdited = Task(
              description: '',
              completed: ''
            );
            notifier.setStackIndex(1);
          }
        ),
        body : ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          itemCount: model.entityList.length,
          itemBuilder: (BuildContext inBuildContext, int inIndex) {
            Task task = model.entityList[inIndex];
            String sDueDate = '';
            if (task.dueDate != null) {
              List dateParts = task.dueDate!.split(",");
              DateTime dueDate = DateTime(
                  int.parse(dateParts[0]), int.parse(dateParts[1]),
                  int.parse(dateParts[2])
              );
              sDueDate =
                  DateFormat.yMMMMd("en_US").format(dueDate.toLocal());
            }
            return Slidable(
                key: ValueKey(task.id),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (context) =>
                          _deleteTask(inBuildContext, task, model, notifier),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  color: Colors.grey.shade300,
                  child: ListTile(
                      leading: Checkbox(
                          value: task.completed == "true" ? true : false,
                          onChanged: (inValue) async {
                            task.completed = inValue.toString();
                            await TasksDBWorker.db.update(task);
                            notifier.loadData("tasks", TasksDBWorker.db);
                          }
                      ),
                      title: Text(
                          "${task.description}",
                          style: task.completed == "true" ?
                          TextStyle(color: Theme
                              .of(context)
                              .disabledColor, decoration: TextDecoration
                              .lineThrough) :
                          TextStyle(color: Theme
                              .of(context)
                              .textTheme
                              .titleLarge
                              ?.color)
                      ),
                      subtitle: task.dueDate == null ? null :
                      Text(sDueDate,
                          style: task.completed == "true" ?
                          TextStyle(color: Theme
                              .of(context)
                              .disabledColor,
                              decoration: TextDecoration.lineThrough) :
                          TextStyle(color: Theme
                              .of(context)
                              .textTheme
                              .titleLarge
                              ?.color)
                      ),
                      onTap: () async {
                        if (task.completed == "true") {
                          return;
                        }
                        model.entityBeingEdited = await TasksDBWorker.db
                            .get(task.id!);
                        if (model.entityBeingEdited.dueDate == null) {
                          notifier.setChosenDate('');
                        } else {
                          notifier.setChosenDate(sDueDate);
                        }
                        notifier.setStackIndex(1);
                      }
                  ),
                )
            );
          }
    ));
  }

  Future _deleteTask(BuildContext inContext, Task inTask, TasksModel inModel,
      TasksModelNotifier notifier) async {
    print("## TasksList._deleteTask(): inTask = $inTask");

    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete Task"),
          content : Text("Are you sure you want to delete ${inTask.description}?"),
          actions : [
            ElevatedButton(child : Text("Cancel"),
              onPressed: () {
                // Just hide dialog.
                Navigator.of(inAlertContext).pop();
              }
            ),
            ElevatedButton(child : Text("Delete"),
              onPressed : () async {
                await TasksDBWorker.db.delete(inTask.id!);
                Navigator.of(inAlertContext).pop();
                ScaffoldMessenger.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("Task deleted")
                  )
                );
                notifier.loadData("tasks", TasksDBWorker.db);
              }
            )
          ]
        );
      }
    );
  }

}
