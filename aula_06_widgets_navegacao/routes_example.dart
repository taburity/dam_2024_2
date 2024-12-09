import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotes example',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/birthdays': (context) => BirthdaysPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/birthdays');
          },
          child: Text('Go to Birthdays Page'),
        ),
      ),
    );
  }
}

class BirthdaysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Birthdays'),
      ),
      body: Center(
        child: Text('This is the Birthdays Page'),
      ),
    );
  }
}
