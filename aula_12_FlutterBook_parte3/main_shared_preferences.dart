import 'package:flutter/material.dart';
import "package:path_provider/path_provider.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "dart:io";
import 'appointments/appointments.dart';
import 'contacts/contacts.dart';
import 'notes/notes.dart';
import 'tasks/tasks.dart';
import "utils.dart" as utils;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("## main(): FlutterBook Starting");
  await startMeUp();
}

Future<void> startMeUp() async {
  Directory docsDir = await getApplicationDocumentsDirectory();
  utils.docsDir = docsDir;
  int lastTabIndex = await getLastTabIndex();
  runApp(FlutterBook(lastTabIndex: lastTabIndex));
}

Future<int> getLastTabIndex() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('lastTabIndex') ?? 0;
}

class FlutterBook extends StatefulWidget {
  final int lastTabIndex;

  FlutterBook({key, required this.lastTabIndex}) : super(key: key);

  @override
  State<FlutterBook> createState() => _FlutterBookState();
}

class _FlutterBookState extends State<FlutterBook> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: widget.lastTabIndex);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        saveLastTabIndex(_tabController.index);
      }
    });
  }

  Future<void> saveLastTabIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastTabIndex', index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("## FlutterBook.build()");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("FlutterBook"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.date_range), text: "Appointments"),
              Tab(icon: Icon(Icons.contacts), text: "Contacts"),
              Tab(icon: Icon(Icons.note), text: "Notes"),
              Tab(icon: Icon(Icons.assignment_turned_in), text: "Tasks"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Appointments(),
            Contacts(),
            Notes(),
            Tasks(),
          ],
        ),
      ),
    );
  }

}

