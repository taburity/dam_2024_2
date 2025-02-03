import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../utils.dart" as utils;
import "tasks_dbworker.dart";
import "tasks_model.dart";


class TasksEntry extends StatelessWidget {

  final TextEditingController _descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    print("## TasksEntry.build()");
    return Consumer<TasksModel>(
        builder: (context, model, child) {
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
                      model.setStackIndex(0);
                    }
                  ),
                  Spacer(),
                  ElevatedButton(child : Text("Save"),
                    onPressed : () {
                      _save(context, model);
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
                        model.entityBeingEdited.description = _descriptionEditingController.text;
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
                        String chosenDate = await utils.selectDate(
                          context, model, model.entityBeingEdited.dueDate
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
      );
  }

  /// Save this contact to the database.
  ///
  /// @param inContext The BuildContext of the parent widget.
  /// @param inModel   The TasksModel.
  void _save(BuildContext inContext, TasksModel inModel) async {
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
    inModel.loadData("tasks", TasksDBWorker.db);

    //Limpar os controladores
    _descriptionEditingController.clear();

    // Retornar para a listagem de notas
    inModel.setStackIndex(0);

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
