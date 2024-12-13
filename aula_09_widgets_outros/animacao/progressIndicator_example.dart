import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  MyApp({ Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();

}

class _MyApp extends State {

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Indicador de progresso'),
        ),
        body: Center(
          child: Column(
            children: [
              Spacer(),
              CircularProgressIndicator(),
              Spacer(),
              LinearProgressIndicator(value: .25,
                backgroundColor: Colors.yellow),
              Spacer()
            ],
          ) ),),);
  }

}