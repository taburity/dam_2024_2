import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black, fontSize: 15)
        )
      )
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final TextStyle customStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        !.copyWith(
          color: Colors.blue,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
    );

    final ThemeData customThemeData = ThemeData(
      textTheme: TextTheme(bodyMedium:
        TextStyle(color: Colors.orange, fontSize: 20))
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: <Widget>[
          Text('Tema personalizado 1',
              style: customStyle
          ),
          Text('Tema global',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text('Tema personalizado 2',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20)
          ),
          Text('Tema personalizado 3',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.green,
                  fontSize: 25)
          ),
          Theme(
            data: customThemeData,
            child: Text('Tema personalizado 4',
              style: customThemeData.textTheme.bodyMedium)
          )
        ]
      ),
    );
  }
}