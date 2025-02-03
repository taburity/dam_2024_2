import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../../utils.dart" as utils;
import "appointments_model_address.dart";


class AppointmentsDBWorker {

  AppointmentsDBWorker._();
  static final AppointmentsDBWorker db = AppointmentsDBWorker._();
  Database? _db;

  Future<Database> get database async {
    if (_db == null) {
      _db = await init();
    }
    print("## appointments AppointmentsDBWorker.get-database(): _db = $_db");
    return _db!;
  }

  Future<Database> init() async {
    String path = join(utils.docsDir.path, "appointments.db");
    print("## appointments AppointmentsDBWorker.init(): path = $path");
    Database db = await openDatabase(path, version : 1, onOpen : (db) { },
      onCreate : (Database inDB, int inVersion) async {
        await inDB.execute(
          "CREATE TABLE IF NOT EXISTS appointments ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "description TEXT,"
            "apptDate TEXT,"
            "apptTime TEXT,"
            "address TEXT"
          ")"
        );
      }
    );
    return db;
  }

  Appointment appointmentFromMap(Map inMap) {
    print("## appointments AppointmentsDBWorker.appointmentFromMap(): inMap = $inMap");
    Appointment appointment = Appointment(
      id: inMap["id"],
      title: inMap["title"],
      description: inMap["description"],
      apptDate: inMap["apptDate"],
      apptTime: inMap["apptTime"],
      address: inMap["address"]
    );
    print("## appointments AppointmentsDBWorker.appointmentFromMap(): appointment = $appointment");
    return appointment;
  }

  Map<String, dynamic> appointmentToMap(Appointment inAppointment) {
    print("## appointments AppointmentsDBWorker.appointmentToMap(): inAppointment = $inAppointment");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inAppointment.id;
    map["title"] = inAppointment.title;
    map["description"] = inAppointment.description;
    map["apptDate"] = inAppointment.apptDate;
    map["apptTime"] = inAppointment.apptTime;
    map["address"] = inAppointment.address;
    print("## appointments AppointmentsDBWorker.appointmentToMap(): map = $map");
    return map;
  }

  Future create(Appointment inAppointment) async {
    print("## appointments AppointmentsDBWorker.create(): inAppointment = $inAppointment");
    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    List val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM appointments");
    var id = val.first["id"];
    if (id == null) { id = 1; }

    // Insert into table.
    return await db.rawInsert(
      "INSERT INTO appointments (id, title, description, apptDate, apptTime, address) VALUES (?, ?, ?, ?, ?, ?)",
      [
        id,
        inAppointment.title,
        inAppointment.description,
        inAppointment.apptDate,
        inAppointment.apptTime,
        inAppointment.address
      ]
    );
  }

  Future<Appointment> get(int inID) async {
    print("## appointments AppointmentsDBWorker.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("appointments", where : "id = ?", whereArgs : [ inID ]);
    print("## appointments AppointmentsDBWorker.get(): rec.first = $rec.first");
    return appointmentFromMap(rec.first);
  }

  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("appointments");
    var list = recs.isNotEmpty ? recs.map((m) => appointmentFromMap(m)).toList() : [ ];
    print("## appointments AppointmentsDBWorker.getAll(): list = $list");
    return list;
  }

  Future update(Appointment inAppointment) async {
    print("## appointments AppointmentsDBWorker.update(): inAppointment = $inAppointment");
    Database db = await database;
    return await db.update(
      "appointments", appointmentToMap(inAppointment), where : "id = ?", whereArgs : [ inAppointment.id ]
    );
  }

  Future delete(int inID) async {
    print("## appointments AppointmentsDBWorker.delete(): inID = $inID");
    Database db = await database;
    return await db.delete("appointments", where : "id = ?", whereArgs : [ inID ]);
  }

}