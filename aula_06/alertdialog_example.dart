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
  Widget build(BuildContext context) {
    _showIt() {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext inContext) {
            return AlertDialog(
                title: Text("Viemos em paz..."),
                content: Center(child:
                Text("... atirar para matar, atirar para matar")
                ),
                actions: [
                  ElevatedButton(
                      child: Text("Me teletransporta!"),
                      onPressed: () {
                        Navigator.of(inContext).pop();
                      }
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