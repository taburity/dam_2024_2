import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "appointments/appointments.dart";
import "contacts/contacts.dart";
import "utils.dart" as utils;
import "notes/notes.dart";
import "tasks/tasks.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("## main(): FlutterBook Starting");
  await startMeUp();
}

Future<void> startMeUp() async {
  Directory docsDir = await getApplicationDocumentsDirectory();
  utils.docsDir = docsDir;
  runApp(FlutterBook());
}

class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("## FlutterBook.build()");
    return MaterialApp(
        home : DefaultTabController(
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
                    ]))));
  }
}