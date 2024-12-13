import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  MyApp({ Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();

}

class _MyApp extends State {
  var _showFirst = true;

  @override
  Widget build(BuildContext context){
    return MaterialApp(home: Scaffold(
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedCrossFade(
                duration: Duration(seconds: 3),
                firstChild: FlutterLogo(
                  style: FlutterLogoStyle.horizontal,
                  size: 100.0,
                ),
                secondChild: FlutterLogo(
                  style: FlutterLogoStyle.stacked,
                  size: 100.0,
                ),
                crossFadeState: _showFirst ?
                  CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
              ElevatedButton(
                child: Text("Cross-fade"),
                onPressed: () {
                  _showFirst = false;
                  setState(() {});
                },
              )
            ],
          )),
    ));
  }
}