import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "appointments/appointments.dart";
import "contacts/contacts.dart";
import "utils.dart" as utils;
import "notes/notes.dart";
import "tasks/tasks.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print("## main(): FlutterBook Starting");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;

    // Simular atraso
    await Future.delayed(Duration(seconds: 5));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FlutterBook()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("## FlutterBook.build()");
    return DefaultTabController(
        length : 4,
        child : Scaffold(
            appBar : AppBar(
                title : Text("FlutterBook"),
                bottom : TabBar(
                    tabs : [
                      Tab(icon : Icon(Icons.date_range), text : "Appointments"),
                      Tab(icon : Icon(Icons.contacts), text : "Contacts"),
                      Tab(icon : Icon(Icons.note), text : "Notes"),
                      Tab(icon : Icon(Icons.assignment_turned_in), text : "Tasks")
                    ])),
            body : TabBarView(
                children : [
                  Appointments(),
                  Contacts(),
                  Notes(),
                  Tasks()
                ])));
  }
}
