import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'screens/loading_screen.dart';
import 'screens/signup_screen.dart'; // Import the signup screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(); // Initialize Firebase
  } catch (e) {
    print("Error initializing Firebase: $e"); // Handle initialization error
  }

  runApp(MechSwiftApp()); // Ensure correct app name
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
      routes: {
        '/signup': (context) => SignupScreen(), // Define route for SignupScreen
      },
    );
  }
}
