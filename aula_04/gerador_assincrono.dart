Stream<int> countTo(int max) async* {
  int i = 0;
  while (i < max){
    await Future.delayed(Duration(seconds: 1));
    yield i++;
  }
}

main() async {
  Stream s = countTo(5);
  await for (int i in s){
    print(i);
  }
}
