import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  // Variables for storing the new data
  String? name, address, specialty, phoneNumber, password;
  bool _isLoading = false;

  // Function to update user profile information
  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      // Get current user
      User? user = _auth.currentUser;

      if (user != null) {
        try {
          // Update Firebase Auth password if changed
          if (password != null && password!.isNotEmpty) {
            await user.updatePassword(password!);
          }

          // Update Firestore database fields
          await _firestore.collection('users').doc(user.uid).update({
            'name': name,
            'address': address,
            'specialty': specialty,
            'phone': phoneNumber,
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile updated successfully!')));

          Navigator.pop(context); // Go back to the dashboard
        } on FirebaseAuthException catch (e) {
          // Handle FirebaseAuth exceptions
          String errorMessage;

          switch (e.code) {
            case 'weak-password':
              errorMessage = 'Password should be at least 6 characters.';
              break;
            case 'requires-recent-login':
              errorMessage = 'Please log in again to update your password.';
              // Optionally, redirect to login or show a dialog
              _showReLoginDialog();
              break;
            case 'user-not-found':
              errorMessage = 'No user found for this email.';
              break;
            case 'invalid-phone-number':
              errorMessage = 'Number not correct.';
              break;
            default:
              errorMessage = 'An unknown error occurred. Please try again.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)));
        } catch (e) {
          // Handle other exceptions
          print("Error updating profile: $e");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update profile.')));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You must be logged in to update profile.')));
      }
    }
  }

  void _showReLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Re-login Required'),
          content: Text('You need to log in again to change your password.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally, navigate to the login screen
                // Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Profile Information')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      onSaved: (value) => name = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Address'),
                      onSaved: (value) => address = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Service Specialty'),
                      onSaved: (value) => specialty = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your specialty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => phoneNumber = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                      onSaved: (value) => password = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null; // It's optional, so no validation needed
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
