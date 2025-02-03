import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:intl/intl.dart';
import 'base_model.dart';

abstract class BaseModelNotifier<T extends BaseModel> extends AutoDisposeNotifier<T> {

  BaseModelNotifier(state);

  void setStackIndex(int index) {
    print("## BaseModel.setStackIndex(): inStackIndex = $index");
    state = state.copyWith(stackIndex: index) as T;
  }

  void loadData(String entityType, dynamic database) async {
    print("## BaseModel.loadData(): entityType = $entityType");
    final entityList = await database.getAll();
    state = state.copyWith(entityList: entityList) as T;
  }

  void setChosenDate(String? inDate) {
    print("## BaseModel.setChosenDate(): inDate = $inDate");
    state = state.copyWith(chosenDate: inDate) as T;
  }

  Future selectDate(BuildContext inContext, [String? inDateString]) async {
    print("## globals.selectDate()");

    DateTime initialDate = DateTime.now();

    if (inDateString != null) {
      List dateParts = inDateString.split(",");
      // Usa ano, mês e dia
      initialDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
          int.parse(dateParts[2]));
    }

    DateTime? picked = await showDatePicker(
        context: inContext,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100)
    );

    if (picked != null) {
      setChosenDate(DateFormat.yMMMMd("en_US").format(picked.toLocal()));
      return "${picked.year},${picked.month},${picked.day}";
    }
  }
}

