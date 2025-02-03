import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "appointments/appointments.dart";
import "contacts/contacts.dart";
import "utils.dart" as utils;
import "notes/notes.dart";
import "tasks/tasks.dart";

void main()  {
  print("## main(): FlutterBook Starting");
  runApp(FlutterBook());
}

class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: initializeResources(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }
            return HomePage();
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Future<void> initializeResources() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
  }
}

class HomePage extends StatelessWidget {
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