import 'package:flutter/material.dart';
import './screen/help_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HelpScreen(),
    );
  }
}
