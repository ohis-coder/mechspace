import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'dart:io'; // For handling files (images)
import '../custom_button.dart'; // Import the custom button

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();

  File? _image; // Variable to store the picked image
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  // Function to pick image from gallery or camera
  Future<void> _pickImage() async {
    final pickedFile = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose an image source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            child: Text('Gallery'),
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      final selectedFile = await _picker.pickImage(source: pickedFile);
      if (selectedFile != null) {
        setState(() {
          _image = File(selectedFile.path); // Set the picked image
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Image Upload Section
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlue[100],
                      border: Border.all(color: Colors.lightBlue, width: 2),
                    ),
                    child: _image != null
                        ? ClipOval(
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.white,
                          ), // Camera icon if no image
                  ),
                ),
                SizedBox(height: 20),
                // Name Input Field
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                // Phone Number Input Field
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),
                // Address Input Field
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                // Mechanic Specialty Input Field
                TextField(
                  controller: _specialtyController,
                  decoration: InputDecoration(
                    labelText: 'Mechanic Service Specialty',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Sign Up Button
                CustomButton(
                  text: 'Sign Up',
                  onPressed: () {
                    // Add signup functionality here
                  },
                ),
                SizedBox(height: 10),
                // Already Have an Account Button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Back to login screen
                  },
                  child: Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
