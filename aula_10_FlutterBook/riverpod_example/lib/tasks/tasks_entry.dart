import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../utils.dart" as utils;
import "tasks_dbworker.dart";
import "tasks_model.dart";
import "tasks_model_provider.dart";


class TasksEntry extends ConsumerWidget {

  final TextEditingController _descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("## TasksEntry.build()");

    final model = ref.watch(tasksModelNotifierProvider);
    final notifier = ref.read(tasksModelNotifierProvider.notifier);

    if (model.entityBeingEdited != null) {
      _descriptionEditingController.text = model.entityBeingEdited.description;
    }

    return Scaffold(
      bottomNavigationBar : Padding(
        padding : EdgeInsets.symmetric(vertical : 0, horizontal : 10),
        child : Row(
          children : [
            ElevatedButton(child : Text("Cancel"),
              onPressed : () {
                FocusScope.of(context).requestFocus(FocusNode());
                notifier.setStackIndex(0);
              }
            ),
            Spacer(),
            ElevatedButton(child : Text("Save"),
              onPressed : () {
                _save(context, model, notifier);
              }
            )
          ]
        )
      ),
      body : Form(
        key : _formKey,
        child : ListView(
          children : [
            ListTile(
              leading : Icon(Icons.description),
              title : TextFormField(
                keyboardType : TextInputType.multiline,
                maxLines : 4,
                decoration : InputDecoration(hintText : "Description"),
                controller : _descriptionEditingController,
                onChanged: (String? inValue){
                  model.entityBeingEdited.description = inValue;
                },
                validator : (String? inValue) {
                  if (inValue!.isEmpty) { return "Please enter a description"; }
                  return null;
                }
              )
            ),
            ListTile(
              leading : Icon(Icons.today),
              title : Text("Due Date"),
              subtitle : Text(model.chosenDate?? ""),
              trailing : IconButton(
                icon : Icon(Icons.edit), color : Colors.blue,
                onPressed : () async {
                  String chosenDate = await notifier.selectDate(
                    context, model.entityBeingEdited.dueDate
                  );
                  model.entityBeingEdited.dueDate = chosenDate;
                                      }
              )
            )
          ]
        )
      )
    );
  }

  void _save(BuildContext inContext, TasksModel inModel, TasksModelNotifier notifier) async {
    print("## TasksEntry._save()");

    // A tarefa não será salva se as entradas do formulário não forem validadas
    if (!_formKey.currentState!.validate()) { return; }

    // Uma nova tarefa foi criada
    if (inModel.entityBeingEdited.id == null) {
      print("## TasksEntry._save(): Creating: ${inModel.entityBeingEdited}");
      await TasksDBWorker.db.create(inModel.entityBeingEdited);
    // Uma tarefa existente está sendo atualizada
    } else {
      print("## TasksEntry._save(): Updating: ${inModel.entityBeingEdited}");
      await TasksDBWorker.db.update(inModel.entityBeingEdited);
    }

    //Atualizar a listagem de tarefas
    notifier.loadData("tasks", TasksDBWorker.db);

    //Limpar os controladores
    _descriptionEditingController.clear();

    // Retornar para a listagem de notas
    notifier.setStackIndex(0);

    // Informar o usuário que a nova tarefa foi salva
    ScaffoldMessenger.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor : Colors.green,
        duration : Duration(seconds : 2),
        content : Text("Task saved")
      )
    );
  }

}
