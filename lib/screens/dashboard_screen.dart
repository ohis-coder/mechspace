import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'update_profile_screen.dart'; // Import the Update Profile screen
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  final String name;
  final String imageUrl;

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
      MaterialPageRoute(builder: (context) => LoginScreen()),
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
      // Drawer for sidebar menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.imageUrl.isNotEmpty
                        ? FileImage(File(widget.imageUrl))
                        : AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Update Profile Information'),
              onTap: () {
                // Navigate to Update Profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: _logout, // Calls logout function
            ),
          ],
        ),
      ),
      // Main content with backdrop
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/mechspace_background.jpg'), // Your custom backdrop
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,  // Changed welcome text color to red
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Update Profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
                    );
                  },
                  child: Text('Update Profile Information'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
