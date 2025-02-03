import "dart:async";
import "dart:io";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import "package:image_picker/image_picker.dart";
import "../utils.dart" as utils;
import "contacts_dbworker.dart";
import "contacts_model.dart";


class ContactsEntry extends StatelessWidget {

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    print("## ContactsEntry.build()");

    return Consumer<ContactsModel>(
        builder: (context, model, child) {
          if (model.entityBeingEdited != null) {
            _nameEditingController.text = model.entityBeingEdited.name;
            _phoneEditingController.text = model.entityBeingEdited.phone;
            _emailEditingController.text = model.entityBeingEdited.email;
          }

          File avatarFile = File(join(utils.docsDir.path, "avatar"));
          if (avatarFile.existsSync() == false) {
            if (model.entityBeingEdited != null && model.entityBeingEdited.id != null) {
              avatarFile = File(join(utils.docsDir.path, model.entityBeingEdited.id.toString()));
            }
          }

          return Scaffold(
            bottomNavigationBar : Padding(
            padding : EdgeInsets.symmetric(vertical : 0, horizontal : 10),
            child : Row(
              children : [
                ElevatedButton(
                  child : Text("Cancel"),
                  onPressed : () {
                    File avatarFile = File(join(utils.docsDir.path, "avatar"));
                    if (avatarFile.existsSync()) {
                      avatarFile.deleteSync();
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                    model.setStackIndex(0);
                  }
                ),
                Spacer(),
                ElevatedButton(
                  child : Text("Save"),
                  onPressed : () { _save(context, model); }
                )
              ]
            )),
            body : Form(
              key : _formKey,
              child : ListView(
                children : [
                  ListTile(
                    title : avatarFile.existsSync() ? Image.file(avatarFile) :
                      Text("No avatar image for this contact"),
                    trailing : IconButton(
                      icon : Icon(Icons.edit),
                      color : Colors.blue,
                      onPressed : () => _selectAvatar(context, model)
                    )
                  ),
                  // Name.
                  ListTile(
                    leading : Icon(Icons.person),
                    title : TextFormField(
                      decoration : InputDecoration(hintText : "Name"),
                      controller : _nameEditingController,
                      onChanged: (String? inValue){
                        model.entityBeingEdited.name = inValue;
                      },
                      validator : (String? inValue) {
                        if (inValue!.isEmpty) { return "Please enter a name"; }
                        return null;
                      }
                    )
                  ),
                  // Phone.
                  ListTile(
                    leading : Icon(Icons.phone),
                    title : TextFormField(
                      keyboardType : TextInputType.phone,
                      decoration : InputDecoration(hintText : "Phone"),
                      controller : _phoneEditingController,
                      onChanged: (String? inValue){
                        model.entityBeingEdited.phone = inValue;
                      },
                    )
                  ),
                  // Email.
                  ListTile(
                    leading : Icon(Icons.email),
                    title : TextFormField(
                      keyboardType : TextInputType.emailAddress,
                      decoration : InputDecoration(hintText : "Email"),
                      controller : _emailEditingController,
                      onChanged: (String? inValue){
                        model.entityBeingEdited.email = inValue;
                      },
                    )
                  ),
                  // Birthday.
                  ListTile(
                    leading : Icon(Icons.today),
                    title : Text("Birthday"),
                    subtitle : Text(model.chosenDate ?? ''),
                    trailing : IconButton(
                      icon : Icon(Icons.edit),
                      color : Colors.blue,
                      onPressed : () async {
                        String chosenDate = await utils.selectDate(
                          context, model, model.entityBeingEdited.birthday
                        );
                        model.entityBeingEdited.birthday = chosenDate;
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

  /// Function for handling taps on the edit icon for avatar.
  ///
  /// @param  inContext The BuildContext of the parent Widget.
  /// @return           Future.
  Future _selectAvatar(BuildContext inContext, ContactsModel inModel) {
    print("ContactsEntry._selectAvatar()");
    return showDialog(context : inContext,
      builder : (BuildContext inDialogContext) {
        return AlertDialog(
          content : SingleChildScrollView(
            child : ListBody(
              children : [
                GestureDetector(
                  child : Text("Take a picture"),
                  onTap : () async {
                    FocusScope.of(inContext).unfocus();
                    var cameraImage = await ImagePicker().pickImage(source : ImageSource.camera);
                    if (cameraImage != null) {
                      final String filePath = cameraImage.path;
                      final File imageFile = File(filePath);
                      final directory = await getApplicationDocumentsDirectory();
                      final String destinationPath = join(directory.path, "avatar");
                      await imageFile.copy(destinationPath);
                      inModel.triggerRebuild();
                    }
                    Navigator.of(inDialogContext).pop();
                  }
                ),
                Padding(padding : EdgeInsets.all(10)),
                GestureDetector(
                  child : Text("Select From Gallery"),
                  onTap : () async {
                    FocusScope.of(inContext).unfocus();
                    var galleryImage = await ImagePicker().pickImage(source : ImageSource.gallery);
                    if (galleryImage != null) {
                      final String filePath = galleryImage.path;
                      final File imageFile = File(filePath);
                      final directory = await getApplicationDocumentsDirectory();
                      final String destinationPath = join(directory.path, "avatar");
                      await imageFile.copy(destinationPath);
                      inModel.triggerRebuild();
                    }
                    Navigator.of(inDialogContext).pop();
                  }
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
  /// @param inModel   The ContactsModel.
  void _save(BuildContext inContext, ContactsModel inModel) async {
    print("## ContactsEntry._save()");
    if (!_formKey.currentState!.validate()) { return; }
    var id;

    if (inModel.entityBeingEdited.id == null) {
      print("## ContactsEntry._save(): Creating: ${inModel.entityBeingEdited}");
      id = await ContactsDBWorker.db.create(inModel.entityBeingEdited);
    } else {
      print("## ContactsEntry._save(): Updating: ${inModel.entityBeingEdited}");
      id = inModel.entityBeingEdited.id;
      await ContactsDBWorker.db.update(inModel.entityBeingEdited);
    }

    File avatarFile = File(join(utils.docsDir.path, "avatar"));
    if (avatarFile.existsSync()) {
      print("## ContactsEntry._save(): Renaming avatar file to id = $id");
      avatarFile.renameSync(join(utils.docsDir.path, id.toString()));
    }

    inModel.loadData("contacts", ContactsDBWorker.db);
    _nameEditingController.clear();
    _phoneEditingController.clear();
    _emailEditingController.clear();
    inModel.setStackIndex(0);

    ScaffoldMessenger.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor : Colors.green,
        duration : Duration(seconds : 2),
        content : Text("Contact saved")
      )
    );
  }

}
