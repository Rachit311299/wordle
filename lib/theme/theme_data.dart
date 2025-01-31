import 'package:flutter/material.dart';

class AppTheme {
  // Cache theme instances
  static final ThemeData lightTheme = _buildLightTheme();
  static final ThemeData darkTheme = _buildDarkTheme();

  // Pre-define colors to avoid recreation
  static final _lightSurfaceColor = Colors.white;
  static final _darkSurfaceColor = Colors.grey[850]!;
  static final _darkBackgroundColor = Colors.grey[900]!;

  static ThemeData _buildLightTheme() {
    const textTheme = TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        surface: _lightSurfaceColor,
        onSurface: Colors.black,
        surfaceVariant: _lightSurfaceColor,
        onSurfaceVariant: Colors.black87,
        outline: Colors.black26,
        surfaceContainerHighest: Colors.grey[100]!,
      ),
      textTheme: textTheme,
    );
  }

  static ThemeData _buildDarkTheme() {
    const textTheme = TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: _darkBackgroundColor,
      colorScheme: ColorScheme.dark(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        surface: _darkSurfaceColor,
        background: _darkBackgroundColor,
        onBackground: Colors.white,
        surfaceVariant: _darkSurfaceColor,
        onSurfaceVariant: Colors.white70,
        outline: Colors.white24,
        surfaceContainerHighest: Colors.grey[800]!,
      ),
      textTheme: textTheme,
    );
  }
}