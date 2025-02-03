import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:path/path.dart";
import "../utils.dart" as utils;
import "contact.dart";
import "contacts_dbworker.dart";
import "contacts_model.dart";
import "contacts_model_provider.dart";


/// Sub-tela de listagem de contatos
class ContactsList extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("## ContactsList.build()");

    final model = ref.watch(contactsModelNotifierProvider);
    final notifier = ref.read(contactsModelNotifierProvider.notifier);

    return Scaffold(
        floatingActionButton : FloatingActionButton(
          child : Icon(Icons.add, color : Colors.white),
          onPressed : () async {
            File avatarFile = File(join(utils.docsDir.path, "avatar"));
            if (avatarFile.existsSync()) {
              avatarFile.deleteSync();
            }
            model.entityBeingEdited = Contact(
                name: '',
                phone: '',
                email: '');
            notifier.setChosenDate(null);
            notifier.setStackIndex(1);
          }
        ),
        body : ListView.builder(
          itemCount : model.entityList.length,
        itemBuilder : (BuildContext inBuildContext, int inIndex) {
            Contact contact = model.entityList[inIndex];
            File avatarFile = File(join(utils.docsDir.path, contact.id.toString()));
            bool avatarFileExists = avatarFile.existsSync();
            print("## ContactsList.build(): avatarFile: $avatarFile -- avatarFileExists=$avatarFileExists");
            return Column(
              children : [
                Slidable(
                  key: ValueKey(contact.id),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (context) => _deleteContact(inBuildContext, contact, model, notifier),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child : Container(
                  margin: EdgeInsets.only(bottom: 8),
                  color: Colors.grey.shade300,
                  child: ListTile(
                    leading : CircleAvatar(
                      backgroundColor : Colors.indigoAccent,
                      foregroundColor : Colors.white,
                      backgroundImage : avatarFileExists ? FileImage(avatarFile) : null,
                      child : avatarFileExists
                          ? null
                          : (contact.name.isNotEmpty)
                            ? Text(contact.name.substring(0, 1).toUpperCase())
                            : null
                    ),
                    title : Text("${contact.name}"),
                    subtitle : contact.phone == null ? null : Text("${contact.phone}"),
                    onTap : () async {
                      _editContact(context, contact, model, notifier);
                    }
                  )
                ),
              )
            ]
          );
        }
      )
    );
  }

Future _editContact(BuildContext inContext, Contact inContact,
    ContactsModel inModel, ContactsModelNotifier notifier) async {
  File avatarFile = File(join(utils.docsDir.path, "avatar"));
  if (avatarFile.existsSync()) {
    avatarFile.deleteSync();
  }

  inModel.entityBeingEdited = await ContactsDBWorker.db.get(inContact.id!);
  if (inModel.entityBeingEdited.birthday == null) {
    notifier.setChosenDate('');
  } else {
    List dateParts = inModel.entityBeingEdited.birthday.split(",");
    DateTime birthday = DateTime(
        int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])
    );
    notifier.setChosenDate(DateFormat.yMMMMd("en_US").format(birthday.toLocal()));
  }
  notifier.setStackIndex(1);
}


Future _deleteContact(BuildContext inContext, Contact inContact,
    ContactsModel inModel, ContactsModelNotifier notifier) async {
  print("## ContactsList._deleteContact(): inContact = $inContact");
  return showDialog(
    context : inContext,
    barrierDismissible : false,
    builder : (BuildContext inAlertContext) {
      return AlertDialog(
        title : Text("Delete Contact"),
        content : Text("Are you sure you want to delete ${inContact.name}?"),
        actions : [
          ElevatedButton(child : Text("Cancel"),
            onPressed: () {
              Navigator.of(inAlertContext).pop();
            }
          ),
          ElevatedButton(child : Text("Delete"),
            onPressed : () async {
              File avatarFile = File(join(utils.docsDir.path, inContact.id.toString()));
              if (avatarFile.existsSync()) {
                avatarFile.deleteSync();
              }
              await ContactsDBWorker.db.delete(inContact.id!);
              Navigator.of(inAlertContext).pop();
              ScaffoldMessenger.of(inContext).showSnackBar(
                SnackBar(
                  backgroundColor : Colors.red,
                  duration : Duration(seconds : 2),
                  content : Text("Contact deleted")
                )
              );
              notifier.loadData("contacts", ContactsDBWorker.db);
            })]);});
}

}
