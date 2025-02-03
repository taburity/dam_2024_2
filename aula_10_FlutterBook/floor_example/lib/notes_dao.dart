import 'package:floor/floor.dart';
import 'note.dart';

@dao
abstract class NotesDao {
  @Query('SELECT * FROM Note')
  Future<List<Note>> getAllNotes();

  @Query('SELECT * FROM Note WHERE id = :id')
  Future<Note?> getNoteById(int id);

  @insert
  Future<void> insertNote(Note note);

  @update
  Future<void> updateNote(Note note);

  @delete
  Future<void> deleteNote(Note note);
}
