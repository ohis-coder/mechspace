import 'package:flutter/material.dart';
import '../custom_button.dart'; // Import the custom button
import 'signup_screen.dart'; // Import the signup screen
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'dashboard_screen.dart'; // Import the dashboard screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _errorMessage = ''; // Clear any previous error message
    });

    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    // Format the phone number into a unique email-like structure
    String email = '$phone@yourapp.com'; // Use a unique domain for your app

    try {
      print('Login Attempt: email: $email, password: $password');
      
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user details from Firestore
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?; // Cast to a Map

          String userName = data?['name'] ?? 'No Name'; // Access 'name' field
          String userImage = data?['image_url'] ?? 'https://example.com/image.jpg'; // Access 'image_url' field

          // Navigate to the dashboard screen on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                name: userName,
                imageUrl: userImage,
              ),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'User data not found in Firestore.';
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for that phone number.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Wrong password provided.';
        } else if (e.code == 'network-request-failed') {
          _errorMessage = 'Network error. Please check your connection.';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Invalid email format. Please check your phone number.';
        } else if (e.code == 'user-disabled') {
          _errorMessage = 'This user account has been disabled.';
        } else {
          _errorMessage = 'Login failed: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 10),
              CustomButton(
                text: 'Login',
                onPressed: _login,
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
