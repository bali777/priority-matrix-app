import 'package:flutter/material.dart';

import 'matrix_screen.dart';

/// The entry point of the app.
///
/// This file must live at `lib/main.dart` — that is the path the Flutter
/// tool looks for when you run `flutter run`.
void main() {
  runApp(const PriorityMatrixApp());
}

/// The root widget of the application.
class PriorityMatrixApp extends StatelessWidget {
  const PriorityMatrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Priority Matrix',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.dark),
      home: const MatrixScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    const primary = Color(0xFF007BFF); // Electric blue.
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    );
    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF121212), // Deep charcoal.
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
