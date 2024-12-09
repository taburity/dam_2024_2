class C {
  E mostrarPrimeiro<E>(List<E> lista){
    E item  = lista[0];
    if(item is num){
      print("É um número");
    }
    print(item);
    return item;
  }

  main(){
    C c = new C();
    c.mostrarPrimeiro(<String>["Java", "Dart"]);

    c.mostrarPrimeiro(<num>[42, 66]);
  }

}