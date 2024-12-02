// ignore_for_file: sort_child_properties_last, prefer_const_constructors

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

    Future _showIt() async {
      switch (await showDialog(
          context: context,
          builder: (BuildContext inContext) {
            return SimpleDialog(
                title: Text("What's your favorite food?"),
                children: [
                  SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(inContext, "brocolli");
                      },
                      child: Text("Brocolli")
                  ),
                  SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(inContext, "steak");
                      },
                      child: Text("Steak")
                  )
                ]
            );
          }
      )) {
        case "brocolli" : print("Brocolli"); break;
        case "steak" : print("Steak"); break;
      }
    }

    return Scaffold(
        body: Center(
            child: ElevatedButton(
                child: Text("Show it"),
                onPressed: _showIt
            )
        )
    );
  }
}