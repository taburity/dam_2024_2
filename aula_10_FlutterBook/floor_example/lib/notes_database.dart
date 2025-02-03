import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'note.dart';
import 'notes_dao.dart';

part 'notes_database.g.dart';

@Database(version: 1, entities: [Note])
abstract class NotesDatabase extends FloorDatabase {
  NotesDao get notesDao;
}
