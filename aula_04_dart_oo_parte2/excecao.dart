class MinhaExcecao implements Exception {
  final String mensagem;
  MinhaExcecao(this.mensagem);

  @override
  String toString() => 'MinhaExcecao: $mensagem';
}

void main() {
  try {
    throw MinhaExcecao('Algo deu errado!');
  } on MinhaExcecao {
    print('Erro meu');
  } catch (e) {
    print('Erro capturado: $e');
  } finally {
    print('Bloco finally executado.');
  }
}
