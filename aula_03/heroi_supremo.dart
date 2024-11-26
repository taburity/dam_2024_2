import 'heroi.dart';

class HeroiSupremo implements Heroi {

  @override
  String? primeiroNome;

  @override
  String? ultimoNome;

  HeroiSupremo(this.primeiroNome, this.ultimoNome);

  String dizerNome(){
    return "Jedi $primeiroNome, $ultimoNome";
  }
}