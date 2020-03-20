import 'package:flutter/material.dart';
import 'package:music_previewer/Screens/first_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,   
      home: FirstScreen(),
    );
  }
}

