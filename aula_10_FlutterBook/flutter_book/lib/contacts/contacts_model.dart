import "../base_model.dart";


///Uma classe que representa um contato
class Contact {

  int? id;
  String name;
  String? phone;
  String? email;
  String? birthday; // YYYY,MM,DD

  Contact({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.birthday,
  });

  String toString() {
    return "{ id=$id, name=$name, phone=$phone, "
        "email=$email, birthday=$birthday }";
  }

}


/// The model backing this entity type's views.
class ContactsModel extends BaseModel {

  void triggerRebuild() {
    print("## ContactsModel.triggerRebuild()");
    notifyListeners();
  }

}
