import 'package:flutter/material.dart';

void main() => runApp(LikesWidget());

class LikesWidget extends StatefulWidget {
  const LikesWidget({super.key});

  @override
  State<LikesWidget> createState() => LikesWidgetState();
}

class LikesWidgetState extends State<LikesWidget> {
  int likeCount = 0;
  void like(){
    setState((){
      likeCount += 1;
    });
  }

  @override
  Widget build (BuildContext context){
    return MaterialApp(home: Scaffold(
        body:  Row(
          children: [
            ElevatedButton(
                onPressed : like,
                child : Text('$likeCount')
            )
          ]
        )
    ));
  }
}