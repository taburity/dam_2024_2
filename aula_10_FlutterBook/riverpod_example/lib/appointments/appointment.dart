///Uma classe que representa um compromisso.
class Appointment {
  int? id;
  String title;
  String description;
  String apptDate; // YYYY,MM,DD
  String? apptTime; // HH,MM

  Appointment({
    this.id,
    required this.title,
    required this.description,
    required this.apptDate,
    this.apptTime,
  });

  String toString() {
    return "{ id=$id, title=$title, description=$description, "
        "apptDate=$apptDate, apptTime=$apptTime }";
  }
}