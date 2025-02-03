import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'contact.dart';
import 'contacts_dbworker.dart';
import 'contacts_model.dart';
import '../base_model_provider.dart';

part 'contacts_model_provider.g.dart';

@riverpod
class ContactsModelNotifier extends BaseModelNotifier<ContactsModel> {
  ContactsModelNotifier() : super(ContactsModel());
  //NotesModelNotifier(super.state);

  ContactsModel build(){
    var model = ContactsModel();
    loadData("notes", ContactsDBWorker.db);
    return model;
  }

  void triggerRebuild() {
    print("## ContactsModel.triggerRebuild()");
  }

  void editContact(Contact contact) {
    state = state.copyWith(entityBeingEdited: contact);
  }

}