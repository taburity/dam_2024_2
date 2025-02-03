import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "contacts_dbworker.dart";
import "contacts_list.dart";
import "contacts_entry.dart";
import "contacts_model.dart";


/// Tela de contatos
class Contacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContactsModel>(
        create: (context) {
          ContactsModel model = ContactsModel();
          model.loadData("contacts", ContactsDBWorker.db);
          return model;
        },
        child: Consumer<ContactsModel>(
            builder: (context, inModel, child) {
              return IndexedStack(
                  index: inModel.stackIndex,
                  children: [
                    ContactsList(),
                    ContactsEntry()
                  ]
              );
            }
        )
    );
  }
}
