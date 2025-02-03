import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils.dart' as utils;
import 'appointments_dbworker.dart';
import 'appointments_model.dart';

class AppointmentsEntry extends StatelessWidget {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("## AppointmentsEntry.build()");
    return Consumer<AppointmentsModel>(

      builder: (context, model, child) {
        if (model.entityBeingEdited != null) {
          _titleEditingController.text = model.entityBeingEdited.title;
          _descriptionEditingController.text = model.entityBeingEdited.description;
        }

        return Scaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Row(
              children: [
                ElevatedButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    model.setStackIndex(0);
                  },
                ),
                Spacer(),
                ElevatedButton(
                  child: Text("Save"),
                  onPressed: () { _save(context, model); },
                ),
              ],
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.subject),
                  title: TextFormField(
                    decoration: InputDecoration(hintText: "Title"),
                    controller: _titleEditingController,
                    onChanged: (String? inValue){
                      model.entityBeingEdited.title = _titleEditingController.text;
                    },
                    validator: (String? inValue) {
                      if (inValue!.isEmpty) {
                        return "Please enter a title";
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.description),
                  title: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(hintText: "Description"),
                    controller: _descriptionEditingController,
                    onChanged: (String? inValue){
                      model.entityBeingEdited.description = inValue;
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.today),
                  title: Text("Date"),
                  subtitle: Text(model.chosenDate ?? ""),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.blue,
                    onPressed: () async {
                      String chosenDate = await utils.selectDate(
                        context, model, model.entityBeingEdited.apptDate,
                      );
                      model.entityBeingEdited.apptDate = chosenDate;
                      },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.alarm),
                  title: Text("Time"),
                  subtitle: Text(model.apptTime),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.blue,
                    onPressed: () => _selectTime(context, model),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _selectTime(BuildContext inContext, AppointmentsModel inModel) async {
    TimeOfDay initialTime = TimeOfDay.now();
    if (inModel.entityBeingEdited.apptTime != null && !inModel.entityBeingEdited.apptTime.isEmpty) {
      List timeParts = inModel.entityBeingEdited.apptTime.split(",");
      initialTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    }

    TimeOfDay? picked = await showTimePicker(context: inContext, initialTime: initialTime);
    if (picked != null) {
      inModel.entityBeingEdited.apptTime = "${picked.hour},${picked.minute}";
      inModel.setApptTime(picked.format(inContext));
    }
  }

  void _save(BuildContext inContext, AppointmentsModel inModel) async {
    //O compromisso não será salvo se as entradas do formulário não forem validadas
    if (!_formKey.currentState!.validate()) return;

    //Um novo compromisso foi criado
    if (inModel.entityBeingEdited.id == null) {
      await AppointmentsDBWorker.db.create(inModel.entityBeingEdited);
    //Um compromisso existente está sendo atualizado
    } else {
      await AppointmentsDBWorker.db.update(inModel.entityBeingEdited);
    }

    //Atualizar a listagem de compromissos
    inModel.loadData("appointments", AppointmentsDBWorker.db);

    //Limpar os controladores
    _titleEditingController.clear();
    _descriptionEditingController.clear();

    // Retornar para a listagem de compromissos
    inModel.setStackIndex(0);

    // Informar o usuário que o novo compromisso foi salvo
    ScaffoldMessenger.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Appointment saved"),
      ),
    );
  }
}
