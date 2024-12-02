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
  Widget build(BuildContext context){
    return Scaffold(
        body: Column(
            children: [
              Container(height: 50),
              Tooltip(
                message: "Clicar aqui destruirá o universo. Cuidado!",
                child: ElevatedButton(
                  child: Text("Não clique!"),
                  onPressed: () { print("BOOM!"); } ,
                )
              )
            ]
        )
    );
  }
}
