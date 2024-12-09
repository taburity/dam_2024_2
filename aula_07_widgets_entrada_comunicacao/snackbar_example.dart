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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
            content: Text("Eu gosto de torta!"),
            action: SnackBarAction(
              label: "Comer",
              onPressed: (){
                print("Ficando gordo!");
              }
            )
        )
      );
    }
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                child: Text("Show it"),
                onPressed: _showIt
            )
        ));}}