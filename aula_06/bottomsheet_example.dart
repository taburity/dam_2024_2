import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(home: Scaffold(body: Home()));
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _showIt() {
      showModalBottomSheet(context: context,
          builder: (BuildContext inContext)
      {
        return new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Qual é o seu animal favorito?"),
              ElevatedButton(child: Text("Cachorro"),
                onPressed: () {
                  Navigator.of(inContext).pop();
                },
              ),
              ElevatedButton(child: Text("Gato"),
                onPressed: () {
                  Navigator.of(inContext).pop();
                },
              ),
              ElevatedButton(child: Text("Coelho"),
                onPressed: () {
                  Navigator.of(inContext).pop();
                },
              )
            ]
        );
      }
      );
    }
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                child: Text("Show it"),
                onPressed: _showIt
            )
        ));}}