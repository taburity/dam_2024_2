import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          title: Text('Exemplo de imagem'),
        ),
        body: Center(
          child:
          Image.network("https://upload.wikimedia.org/wikipedia/commons/8/87/"+
              "Google_Chrome_icon_%282011%29.png")
      ),
      ),
    );
  }

}