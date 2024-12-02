// ignore_for_file: prefer_final_fields, prefer_const_constructors, sort_child_properties_last, avoid_print

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();

}

class LoginData {
  String username = "";
  String password = "";
}

class _MyApp extends State<MyApp> {
  LoginData _loginData = LoginData();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey _btnKey = GlobalKey();

  @override
  Widget build(BuildContext context){
    return MaterialApp(home: Scaffold(
      body: Container(
        padding: EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (inValue) {
                  if(inValue!.isEmpty){
                    return "Please enter username";
                  }
                  return null;
                },
                onSaved: (inValue){
                  _loginData.username = inValue!;
                },
                decoration: InputDecoration(
                  hintText: "none@none.com",
                  labelText: "Username (eMail address)"
                )
              ),
              TextFormField(
                obscureText: true,
                validator: (inValue){
                  if(inValue!.length < 10){
                    return "Password must be >=10 in length";
                  }
                  return null;
                },
                onSaved: (inValue){
                  _loginData.password = inValue!;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password"
                )
              ),
              ElevatedButton(
                child: Text("Log In"),
                key: _btnKey,
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    print("Username: ${_loginData.username}");
                    print("Password: ${_loginData.password}");
                  }
                  print(((
                    _btnKey.currentWidget as ElevatedButton).child as Text).data
                  );
                }
              )
            ],
          ),
        ),
      )
    ));
  }

}
