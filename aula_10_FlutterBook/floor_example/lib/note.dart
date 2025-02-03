import 'package:floor/floor.dart';

@entity
class Note {
  @primaryKey
  final int? id;
  final String title;
  final String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content}';
  }
}
