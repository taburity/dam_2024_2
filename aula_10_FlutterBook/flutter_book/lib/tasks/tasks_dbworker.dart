import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "tasks_model.dart";


/// Classe que provê acesso ao banco de dados para gerenciar tarefas.
class TasksDBWorker {

  /// Construtor privado
  TasksDBWorker._();
  static final TasksDBWorker db = TasksDBWorker._();

  /// Instância única do banco
  Database? _db;

  /// Método para obter singleton
  Future get database async {
    if (_db == null) {
      _db = await init();
    }
    print("## tasks TasksDBWorker.get-database(): _db = $_db");
    return _db!;
  }

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    print("## Tasks TasksDBWorker.init()");
    String path = join(utils.docsDir.path, "tasks.db");
    print("## tasks TasksDBWorker.init(): path = $path");
    Database db = await openDatabase(path, version : 1, onOpen : (db) { },
      onCreate : (Database inDB, int inVersion) async {
        await inDB.execute(
          "CREATE TABLE IF NOT EXISTS tasks ("
            "id INTEGER PRIMARY KEY,"
            "description TEXT,"
            "dueDate TEXT,"
            "completed TEXT"
          ")"
        );
      }
    );
    return db;
  }

  /// Criar uma tarefa a partir de um mapa
  Task taskFromMap(Map inMap) {
    print("## Tasks TasksDBWorker.taskFromMap(): inMap = $inMap");
    Task task = Task(
      id: inMap["id"],
      description: inMap["description"],
      dueDate: inMap["dueDate"],
      completed: inMap["completed"]);
    print("## Tasks TasksDBWorker.taskFromMap(): task = $task");
    return task;
  }

  /// Criar um mapa a partir de uma tarefa
  Map<String, dynamic> taskToMap(Task inTask) {
    print("## tasks TasksDBWorker.taskToMap(): inTask = $inTask");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inTask.id;
    map["description"] = inTask.description;
    map["dueDate"] = inTask.dueDate;
    map["completed"] = inTask.completed;
    print("## tasks TasksDBWorker.taskToMap(): map = $map");
    return map;
  }

  /// Create a task.
  ///
  /// @param  inTask The Task object to create.
  /// @return        Future.
  Future create(Task inTask) async {
    print("## Tasks TasksDBWorker.create(): inTask = $inTask");
    Database db = await database;
    // Get largest current id in the table, plus one, to be the new ID.
    List val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM tasks");
    var id = val.first["id"];
    if (id == null) { id = 1; }

    // Insere a tarefa no banco. Poderia usar o método db.insert, para evitar escrever o código sql
    return await db.rawInsert(
      "INSERT INTO tasks (id, description, dueDate, completed) VALUES (?, ?, ?, ?)",
      [
        id,
        inTask.description,
        inTask.dueDate,
        inTask.completed
      ]
    );
  }

  /// Get a specific task.
  ///
  /// @param  inID The ID of the task to get.
  /// @return      The corresponding Task object.
  Future<Task> get(int inID) async {
    print("## Tasks TasksDBWorker.get(): inID = $inID");
    Database db = await database;
    var rec = await db.query("tasks", where : "id = ?", whereArgs : [ inID ]);
    print("## Tasks TasksDBWorker.get(): rec.first = $rec.first");
    return taskFromMap(rec.first);
  }

  /// Get all tasks.
  ///
  /// @return A List of Task objects.
  Future<List> getAll() async {
    print("## Tasks TasksDBWorker.getAll()");
    Database db = await database;
    var recs = await db.query("tasks");
    var list = recs.isNotEmpty ? recs.map((m) => taskFromMap(m)).toList() : [ ];
    print("## Tasks TasksDBWorker.getAll(): list = $list");
    return list;
  }

  /// Update a task.
  ///
  /// @param  inTask The task to update.
  /// @return        Future.
  Future update(Task inTask) async {
    print("## Tasks TasksDBWorker.update(): inTask = $inTask");
    Database db = await database;
    return await db.update("tasks", taskToMap(inTask), where : "id = ?", whereArgs : [ inTask.id ]);
  }

  /// Delete a task.
  ///
  /// @param  inID The ID of the task to delete.
  /// @return      Future.
  Future delete(int inID) async {
    print("## Taasks TasksDBWorker.delete(): inID = $inID");
    Database db = await database;
    return await db.delete("Tasks", where : "id = ?", whereArgs : [ inID ]);
  }

}