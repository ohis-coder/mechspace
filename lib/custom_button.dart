import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue, // Updated for button color
        foregroundColor: Colors.white, // Text color
        padding: EdgeInsets.symmetric(vertical: 16.0), // Padding for the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 16.0)),
    );
  }
}
