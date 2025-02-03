import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "tasks_list.dart";
import "tasks_entry.dart";
import "tasks_model_provider.dart";


/// Tela de tarefas
class Tasks extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksModel = ref.watch(tasksModelNotifierProvider);

    return IndexedStack(
        index: tasksModel.stackIndex,
        children: [
          TasksList(),
          TasksEntry()
        ]
    );
  }
}