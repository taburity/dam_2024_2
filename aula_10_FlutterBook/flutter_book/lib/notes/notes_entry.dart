import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "notes_dbworker.dart";
import "notes_model.dart";


class NotesEntry extends StatelessWidget {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    print("## NotesEntry.build()");
    return Consumer<NotesModel>(
        builder: (context, model, child) {
          if (model.entityBeingEdited != null) {
            _titleEditingController.text = model.entityBeingEdited.title;
            _contentEditingController.text = model.entityBeingEdited.content;
          }

          return Scaffold(
            bottomNavigationBar : Padding(
              padding : EdgeInsets.symmetric(vertical : 0, horizontal : 10),
              child : Row(
                children : [
                  ElevatedButton(
                    child : Text("Cancel"),
                    onPressed : () {
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
              )
            ),
            body : Form(
              key : _formKey,
              child : ListView(
                children : [
                  ListTile(
                    leading : Icon(Icons.title),
                    title : TextFormField(
                      decoration : InputDecoration(hintText : "Title"),
                      controller : _titleEditingController,
                      onChanged: (String? inValue){
                        model.entityBeingEdited.title = inValue;
                      },
                      validator : (String? inValue) {
                        if (inValue!.isEmpty) { return "Please enter a title"; }
                        return null;
                      }
                    )
                  ),
                  ListTile(
                    leading : Icon(Icons.content_paste),
                    title : TextFormField(
                      keyboardType : TextInputType.multiline, maxLines : 8,
                      decoration : InputDecoration(hintText : "Content"),
                      controller : _contentEditingController,
                      onChanged: (String? inValue){
                        model.entityBeingEdited.content = inValue;
                      },
                      validator : (String? inValue) {
                        if (inValue!.isEmpty) { return "Please enter content"; }
                        return null;
                      }
                    )
                  ),
                  ListTile(
                    leading : Icon(Icons.color_lens),
                    title : Row(
                      children : [
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.red, width : 18) +
                              Border.all(
                                width : 6,
                                color : model.color == "red" ? Colors.red : Theme.of(context).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            model.entityBeingEdited.color = "red";
                            model.setColor("red");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.green, width : 18) +
                              Border.all(
                                width : 6,
                                color : model.color == "green" ? Colors.green : Theme.of(context).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            model.entityBeingEdited.color = "green";
                            model.setColor("green");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.blue, width : 18) +
                              Border.all(
                                width : 6,
                                color : model.color == "blue" ? Colors.blue : Theme.of(context).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            model.entityBeingEdited.color = "blue";
                            model.setColor("blue");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.yellow, width : 18) +
                              Border.all(
                                width : 6,
                                color : model.color == "yellow" ? Colors.yellow : Theme.of(context).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            model.entityBeingEdited.color = "yellow";
                            model.setColor("yellow");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.grey, width : 18) +
                              Border.all(
                                width : 6,
                                color : model.color == "grey" ? Colors.grey : Theme.of(context).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            model.entityBeingEdited.color = "grey";
                            model.setColor("grey");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.purple, width : 18) +
                              Border.all(
                                width : 6,
                                color : model.color == "purple" ? Colors.purple : Theme.of(context).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            model.entityBeingEdited.color = "purple";
                            model.setColor("purple");
                          }
                        )
                      ]
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
  /// @param inModel   The NotesModel.
  void _save(BuildContext inContext, NotesModel inModel) async {
    print("## NotesEntry._save()");

    if (!_formKey.currentState!.validate()) { return; }

    if (inModel.entityBeingEdited.id == null) {
      print("## NotesEntry._save(): Creating: ${inModel.entityBeingEdited}");
      await NotesDBWorker.db.create(inModel.entityBeingEdited);
    } else {
      print("## NotesEntry._save(): Updating: ${inModel.entityBeingEdited}");
      await NotesDBWorker.db.update(inModel.entityBeingEdited);
    }

    inModel.loadData("notes", NotesDBWorker.db);

    _titleEditingController.clear();
    _contentEditingController.clear();

    inModel.setStackIndex(0);

    ScaffoldMessenger.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor : Colors.green,
        duration : Duration(seconds : 2),
        content : Text("Note saved")
      )
    );
  }

}
