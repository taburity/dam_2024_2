class Heroi {
  String? primeiroNome;
  String? ultimoNome;
  static String cumprimento = "Olá";

  Heroi.construir(this.primeiroNome, this.ultimoNome);

  String dizerNome(){
    return "$ultimoNome, $primeiroNome";
  }

  static dizerOla(){
    print(Heroi.cumprimento);
  }
}

class HeroiSupremo extends Heroi {

  HeroiSupremo(pn, un) : super.construir(pn, un);

  String dizerNome() {
    return "Jedi $ultimoNome, $primeiroNome";
  }

}