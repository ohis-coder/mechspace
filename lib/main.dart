import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(MechSwiftApp());
}

class MechSwiftApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MechSwift',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        brightness: Brightness.light,
      ),
      home: LoadingScreen(),
    );
  }
}
