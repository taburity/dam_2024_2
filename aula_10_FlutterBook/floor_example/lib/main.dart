import 'package:flutter/material.dart';
import 'notes_database.dart';
import 'note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar o banco de dados
  final database = await $FloorNotesDatabase.databaseBuilder('notes.db').build();
  final notesDao = database.notesDao;

  // Inserir uma nova nota
  final newNote = Note(
    title: 'Exemplo de Nota',
    content: 'Este é o conteúdo da nota.',
  );
  await notesDao.insertNote(newNote);

  // Recuperar todas as notas
  final notes = await notesDao.getAllNotes();
  for (var note in notes) {
    print(note);
  }

  runApp(MyApp(notes: notes));
}

class MyApp extends StatelessWidget {
  final List<Note> notes;

  MyApp({required this.notes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Floor Example')),
        body: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(note.content),
            );
          },
        ),
      ),
    );
  }
}