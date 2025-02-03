import "../../base_model.dart";


///Uma classe que representa um compromisso.
class Appointment {
  int? id;
  String title;
  String description;
  String apptDate; // YYYY,MM,DD
  String? apptTime; // HH,MM
  String? address;

  Appointment({
    this.id,
    required this.title,
    required this.description,
    required this.apptDate,
    this.apptTime,
    this.address
  });

  String toString() {
    return "{ id=$id, title=$title, description=$description, "
        "apptDate=$apptDate, apptTime=$apptTime, address=$address }";
  }
}


/// The model backing this entity type's views.
class AppointmentsModel extends BaseModel {
  String apptTime;
  String address;

  AppointmentsModel({
    required this.apptTime,
    required this.address
  });

  void setApptTime(String inApptTime) {
    apptTime = inApptTime;
    notifyListeners();
  }

  void setApptAddress(String inApptAddress){
    address = inApptAddress;
    notifyListeners();
  }
}