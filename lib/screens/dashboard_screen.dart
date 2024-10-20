import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'login_screen.dart'; // Import the login screen
import 'dart:io';

class DashboardScreen extends StatefulWidget { 
  final String name; 
  final String imageUrl; 

  // Constructor to accept name and imageUrl 
  DashboardScreen({required this.name, required this.imageUrl}); 

  @override 
  _DashboardScreenState createState() => _DashboardScreenState(); 
} 

class _DashboardScreenState extends State<DashboardScreen> { 
  final FirebaseAuth _auth = FirebaseAuth.instance; 

  // Logout function
  void _logout() async { 
    await _auth.signOut(); // Sign out user from Firebase

    // Clear navigation stack and push login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your actual login screen
      (Route<dynamic> route) => false, 
    ); 
  } 

  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('Dashboard'), 
        backgroundColor: Colors.lightBlue, 
      ), 
      body: Center( 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
            CircleAvatar( 
              radius: 50, 
              backgroundImage: File(widget.imageUrl).existsSync()
                  ? FileImage(File(widget.imageUrl)) 
                  : AssetImage('assets/default_avatar.png') as ImageProvider, 
            ), 
            SizedBox(height: 20), 
            Text( 
              'Welcome, ${widget.name}!', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
            ), 
            SizedBox(height: 10), 
            Text( 
              'Here you can manage your account, and more.', 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 16), 
            ), 
            SizedBox(height: 40), 
            ElevatedButton( 
              onPressed: () { 
                Navigator.pushNamed(context, '/mechanic_services'); 
              }, 
              child: Text('View Mechanic Services'), 
              style: ElevatedButton.styleFrom( 
                backgroundColor: Colors.lightBlue, 
              ), 
            ), 
            SizedBox(height: 20), 
            ElevatedButton( 
              onPressed: _logout, 
              child: Text('Logout'), 
              style: ElevatedButton.styleFrom( 
                backgroundColor: Colors.red, 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}
