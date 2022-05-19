import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/provider/loction_provider.dart';
import './screen/help_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationProvider(),
      child: MaterialApp(
        title: 'Weather APP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HelpScreen(),
      ),
    );
  }
}
