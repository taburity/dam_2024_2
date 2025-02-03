/// Código de utilidade geral

import "dart:io";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "base_model.dart";

/// O diretório de documentos da aplicação - única instância
Directory docsDir = Directory.systemTemp;



Future selectDate(BuildContext inContext, BaseModel inModel, [String? inDateString]) async {
  print("## globals.selectDate()");

  DateTime initialDate = DateTime.now();
  if (inDateString != null) {
    List dateParts = inDateString.split(",");
    // Usa ano, mês e dia
    initialDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
  }

  DateTime? picked = await showDatePicker(
      context : inContext,
      initialDate : initialDate,
      firstDate : DateTime(1900),
      lastDate : DateTime(2100)
  );

  if (picked != null) {
    inModel.setChosenDate(DateFormat.yMMMMd("en_US").format(picked.toLocal()));
    return "${picked.year},${picked.month},${picked.day}";
  }
}