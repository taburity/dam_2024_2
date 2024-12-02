// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();

}

class _MyApp extends State<MyApp> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _checkboxValue = false;
  var _switchValue = false;
  var _sliderValue = .3;
  var _radioValue = 1;

  @override
  Widget build(BuildContext context){
    return MaterialApp(home: Scaffold(
      body: Container(
        padding: EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Checkbox(
                value: _checkboxValue,
                onChanged: (inValue){
                  setState(() { _checkboxValue = inValue!; });
                }
              ),
              Switch(
                  value: _switchValue,
                  onChanged: (inValue){
                    setState(() { _switchValue = inValue; });
                  }
              ),
              Slider(
                  min: 0, max: 20,
                  value: _sliderValue,
                  onChanged: (inValue){
                    setState(() { _sliderValue = inValue; });
                  }
              ),
              Row(children: [
                Radio(value: 1, groupValue: _radioValue,
                onChanged: (inValue){
                  setState(() { _radioValue = inValue!; });
                }
                ),
                Text("Option 1")
              ]),
              Row(children: [
                Radio(value: 2, groupValue: _radioValue,
                  onChanged: (inValue){
                    setState(() { _radioValue = inValue!; });
                  }
                ),
                Text("Option 2")
              ]),
              Row(children: [
                Radio(value: 3, groupValue: _radioValue,
                  onChanged: (inValue){
                    setState(() { _radioValue = inValue!; });
                  }
                ),
                Text("Option 3")
              ])
            ]
          ),
        )
      )
    ));
  }

}
