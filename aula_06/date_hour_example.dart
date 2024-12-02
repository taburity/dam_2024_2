import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(home: Scaffold(body: Home()));
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Column(
            children: [
              Container(height: 50),
              ElevatedButton(
                  child: Text("Test DatePicker"),
                  onPressed: () => _selectDate(context)
              ),
              ElevatedButton(
                  child: Text("Test TimePicker"),
                  onPressed: () => _selectTime(context)
              )
            ]
        )
    );
  }

  Future<void> _selectDate(inContext) async {
    DateTime? selectedDate = await showDatePicker(
        context: inContext,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025)
    );
    print(selectedDate);
  }

  Future<void> _selectTime(inContext) async {
    TimeOfDay? selectedTime = await showTimePicker(
        context: inContext,
        initialTime: TimeOfDay.now()
    );
    print(selectedTime);
  }



}
