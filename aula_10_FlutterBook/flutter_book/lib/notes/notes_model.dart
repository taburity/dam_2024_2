import "../base_model.dart";


///Uma classe que representa uma nota
class Note {
  int? id;
  String title;
  String content;
  String color;

  //Assegura que todos os campos são fornecidos na instanciação
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color
  });

  String toString() {
    return "{ id=$id, title=$title, content=$content, color=$color }";
  }

}


/// The model backing this entity type's views.
class NotesModel extends BaseModel {

  /// A cor da nota. Necessário para conseguir exibir a nota com a cor escolhida pelo usuário
  String color;

  NotesModel({required this.color});

  /// For display of the color chosen by the user.
  ///
  /// @param inColor The color.
  void setColor(String inColor) {
    print("## NotesModel.setColor(): inColor = $inColor");
    color = inColor;
    notifyListeners();
  }

}

