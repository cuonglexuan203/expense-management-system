import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      fontFamily: 'Nunito',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Nunito'),
        bodyLarge: TextStyle(fontFamily: 'Nunito'),
        bodyMedium: TextStyle(fontFamily: 'Nunito'),
        labelLarge: TextStyle(fontFamily: 'Nunito'),
        // Customize other text styles if needed
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // Text color
        ),
      ),
    );
  }
}
