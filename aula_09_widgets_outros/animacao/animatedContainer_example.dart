import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  MyApp({ Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();

}

class _MyApp extends State {
  var _color = Colors.yellow;
  var _height = 200.0;
  var _width = 200.0;

  @override
  Widget build(BuildContext context){
    return MaterialApp(home: Scaffold(
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                  duration: Duration(seconds: 3),
                color: _color, width: _width, height: _height
              ),
              ElevatedButton(
                child: Text("Animate"),
                onPressed: () {
                  _color = Colors.red;
                  _height = 400.0;
                  _width = 400.0;
                  setState(() {});
                },
              )
            ],
          )),
    ));
  }
}