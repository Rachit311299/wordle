import 'package:flutter/material.dart';

class AppTheme {
  // Cache theme instances
  static final ThemeData lightTheme = _buildLightTheme();
  static final ThemeData darkTheme = _buildDarkTheme();

  // Pre-define colors to avoid recreation
  static final _lightSurfaceColor = Colors.white;
  static final _darkSurfaceColor = Colors.grey[850]!;
  static final _darkBackgroundColor = Colors.grey[900]!;

  static final gameColors = _GameColors();

  static ThemeData _buildLightTheme() {
    const textTheme = TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF333333)),
      bodyMedium: TextStyle(color: Color(0xFF333333)),
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
        onSurface: const Color.fromARGB(255, 10, 10, 10),
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

class _GameColors {
  // Grid element colors
  final Color lightDefaultGrey = const Color.fromARGB(255, 100, 100, 100);
  final Color darkDefaultGrey = Colors.grey[900]!;
  
  // Key colors
  final Color lightKeyDefault = const Color.fromARGB(44, 73, 73, 73);
  final Color darkKeyDefault = Colors.grey[800]!;
  final Color lightKeyUsed = Colors.grey[700]!;
  final Color darkKeyUsed = Colors.grey[900]!;
  
  // Text colors
  final Color lightTextColor = Colors.black;
  final Color darkTextColor = Colors.white;
  
  // Icon colors
  final Color lightIconColor = Colors.black87;
  final Color darkIconColor = Colors.white70;
  
  // Game colors (theme independent)
  final Color correctColor = Colors.green[600]!;
  final Color misplacedColor = Colors.orange[400]!;
  
  // Get the appropriate color based on brightness
  Color getDefaultGrey(Brightness brightness) => 
      brightness == Brightness.dark ? darkDefaultGrey : lightDefaultGrey;
  
  Color getKeyDefault(Brightness brightness) => 
      brightness == Brightness.dark ? darkKeyDefault : lightKeyDefault;
  
  Color getKeyUsed(Brightness brightness) => 
      brightness == Brightness.dark ? darkKeyUsed : lightKeyUsed;
      
  Color getTextColor(Brightness brightness) => 
      brightness == Brightness.dark ? darkTextColor : lightTextColor;
      
  Color getIconColor(Brightness brightness) => 
      brightness == Brightness.dark ? darkIconColor : lightIconColor;
}