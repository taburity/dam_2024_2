// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: "Flutter Playground",
        home: Scaffold(
            body: Center(
              child: Row(
                children: [
                  Text("Child1"),
                  Divider(),
                  Text("Child2"),
                  Divider(),
                  Text("Child3")
                ]
              ),
            )
        )
    );
  }
}