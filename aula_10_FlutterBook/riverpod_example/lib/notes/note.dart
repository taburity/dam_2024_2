///Uma classe que representa uma nota
class Note {
  int? id;
  String title;
  String content;
  String color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color
  });

  @override
  String toString() {
    return "{ id=$id, title=$title, content=$content, color=$color }";
  }

}