import 'dart:io';

void main() {
  stdout.writeln('Digite o seu nome:');
  String? nome = stdin.readLineSync();

  if (nome != null && nome.isNotEmpty) {
    stdout.writeln('Olá, $nome!');
  } else {
    print('Você não digitou um nome válido.');
  }
}
