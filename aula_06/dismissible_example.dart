import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(home: Scaffold(body: Home()));
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Column(
            children: [
              Container(height: 50),
              Dismissible(
                  key: GlobalKey(),
                  onDismissed: (direction) { print("Goodbye!"); },
                  child: Container(
                    color: Colors.yellow, width: 100, height: 50,
                    child: Text("Swipe me")
                  )
              )
            ]
        )
    );
  }
}
