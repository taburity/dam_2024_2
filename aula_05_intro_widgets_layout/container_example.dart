// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: "Flutter Playground",
        home: Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text("Child1"),
                  Container(padding: EdgeInsets.all(20.0), child: Text("Child2")),
                  Text("Child3")
                ]
              ),
            )
        )
    );
  }
}