import "package:flutter/material.dart";

/// Toda classe de modelo deve estender ChangeNotifier
/// Poderia ser mixin (with) ao invés de herança (extends), mas não precisamos misturar outros comportamentos
class BaseModel extends ChangeNotifier {

  int stackIndex = 0;
  List entityList = [ ];
  var entityBeingEdited;
  String? chosenDate;

  /// Para exibir a data escolhida pelo usuário. Ao selecionar, o widget da tela atual precisa ser atualizado
  /// para exibir a data escolhida ou então o modelo será atualizado, mas o widget que o usuário enxerga, não.
  /// @param inDate A data no formato MM/DD/YYYY.
  void setChosenDate(String? inDate) {
    print("## BaseModel.setChosenDate(): inDate = $inDate");
    chosenDate = inDate;
    notifyListeners();
  }

  /// Carregar dados do banco de dados
  ///
  /// @param inEntityType The type of entity being loaded ("appointments", "contacts", "notes" or "tasks").
  /// @param inDatabase   The DBProvider.db instance for the entity.
  void loadData(String inEntityType, dynamic inDatabase) async {
    print("## ${inEntityType}Model.loadData()");
    entityList = await inDatabase.getAll();
    notifyListeners();
  }

  /// Para navegação entre visões de entrada (cadastro) e listagem.
  ///
  /// @param inStackIndex The stack index to make current.
  void setStackIndex(int inStackIndex) {
    print("## BaseModel.setStackIndex(): inStackIndex = $inStackIndex");
    stackIndex = inStackIndex;
    notifyListeners();
  }

}
