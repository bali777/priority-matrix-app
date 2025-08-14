// Import the necessary Flutter packages.
import 'package:flutter/material.dart';
import 'matrix_screen.dart'; // We will create this file next.

// The main() function is the starting point of every Flutter app.
void main() {
  runApp(const PriorityMatrixApp());
}

// This is the root widget of our application.
class PriorityMatrixApp extends StatelessWidget {
  const PriorityMatrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Priority Matrix',
      // We are defining our dark theme here.
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF007BFF), // Our Electric Blue
        scaffoldBackgroundColor: const Color(0xFF121212), // Deep charcoal background
        fontFamily: 'Inter', // Our chosen font (would be configured in project settings)
      ),
      // Removes the "debug" banner from the corner of the app.
      debugShowCheckedModeBanner: false,
      // Sets the home screen to be the MatrixScreen widget.
      home: const MatrixScreen(),
    );
  }
}
