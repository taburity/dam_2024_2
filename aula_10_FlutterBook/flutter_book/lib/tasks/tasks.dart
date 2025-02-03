import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "tasks_dbworker.dart";
import "tasks_list.dart";
import "tasks_entry.dart";
import "tasks_model.dart";


/// Tela de tarefas
class Tasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<TasksModel>(
        create: (context) {
          TasksModel model = TasksModel();
          model.loadData("tasks", TasksDBWorker.db);
          return model;
        },

        child: Consumer<TasksModel>(
            builder: (context, inModel, child) {
              return IndexedStack(
                  index: inModel.stackIndex,
                  children: [
                    TasksList(),
                    TasksEntry()
                  ]
              );
            }
        )
    );
  }
}
