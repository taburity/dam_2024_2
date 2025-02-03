import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../utils.dart' as utils;
import 'appointments_dbworker.dart';
import 'appointments_model_address.dart';
import 'map_screen.dart';

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
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Location"),
                  subtitle: Text(model.address.isNotEmpty ? model.address : "Tap to select"),
                  trailing: IconButton(
                    icon: Icon(Icons.map),
                    color: Colors.blue,
                    onPressed: () => _selectLocation(context),
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
    if (!_formKey.currentState!.validate()) return;

    if (inModel.entityBeingEdited.id == null) {
      await AppointmentsDBWorker.db.create(inModel.entityBeingEdited);
    } else {
      await AppointmentsDBWorker.db.update(inModel.entityBeingEdited);
    }

    inModel.loadData("appointments", AppointmentsDBWorker.db);
    _titleEditingController.clear();
    _descriptionEditingController.clear();
    inModel.setStackIndex(0);

    ScaffoldMessenger.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Appointment saved"),
      ),
    );
  }

  /* Essa versão não funciona porque o provider não é global*/
  /*Future _selectLocation(BuildContext inContext, AppointmentsModel inModel) async {
    bool allowed = await _checkPermission();
    if (!allowed) return;

    final selectedAddress = await Navigator.push(
      inContext,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );

    if (selectedAddress != null && selectedAddress is String) {
      inModel.entityBeingEdited.address = selectedAddress;
      inModel.setApptAddress(selectedAddress);
    }
  }*/

  Future _selectLocation(BuildContext inContext) async {
    bool allowed = await _checkPermission();
    if (!allowed) return;

    final selectedAddress = await Navigator.push(
      inContext,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: Provider.of<AppointmentsModel>(inContext, listen: false),
          child: MapScreen(),
        ),
      ),
    );

    if (selectedAddress != null && selectedAddress is String) {
      final inModel = Provider.of<AppointmentsModel>(inContext, listen: false);
      inModel.entityBeingEdited.address = selectedAddress;
      inModel.setApptAddress(selectedAddress);
    }
  }


  Future<bool> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    return true;
  }

}
