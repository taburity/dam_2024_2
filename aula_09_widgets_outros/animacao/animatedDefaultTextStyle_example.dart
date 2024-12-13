import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  MyApp({ Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();

}

class _MyApp extends State {
  var _color = Colors.red;
  var _fontSize = 20.0;

  @override
  Widget build(BuildContext context){
    return MaterialApp(home: Scaffold(
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: Duration(seconds: 3),
                style: TextStyle(
                  color: _color, fontSize: _fontSize
                ),
                child: Text("Texto qualquer")
              ),
              ElevatedButton(
                child: Text("Enhance!"),
                onPressed: () {
                  _color = Colors.blue;
                  _fontSize = 40.0;
                  setState(() {});
                },
              )
            ],
          )),
    ));
  }
}