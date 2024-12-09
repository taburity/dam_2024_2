Iterable<int> countTo(int max) sync* {
  int i = 0;
  while (i < max){
    yield i++;
  }
}

main() {
  Iterable it = countTo(5);
  Iterator i = it.iterator;
  while(i.moveNext()){
    print(i.current);
  }
}
