import 'package:flutter/material.dart';

class AppTheme {
  // Cache theme instances
  static final ThemeData lightTheme = _buildLightTheme();
  static final ThemeData darkTheme = _buildDarkTheme();

  // Pre-define colors to avoid recreation
  static final _lightSurfaceColor = const Color(0xFFF0E5D4);
  static final _darkSurfaceColor = const Color(0xFF2C1A10);
  static final _darkBackgroundColor = Colors.grey[900]!;

  static final gameColors = _GameColors();

  static ThemeData _buildLightTheme() {
    const textTheme = TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF261816)),
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
        onSurface: const Color(0xFF0A0A0A),
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
  final Color lightDefaultGrey = const Color(0xFF73502D);
  final Color darkDefaultGrey = const Color(0xFF502B11);
  
  // Key colors
  final Color lightKeyDefault = const Color(0xFFE0CEB5);
  final Color darkKeyDefault = const Color.fromARGB(255, 125, 99, 80);
  final Color lightKeyUsed = const Color(0xFF86592D);
  final Color darkKeyUsed = const Color(0xFF502B11);
  
  // Text colors
  final Color lightTextColor = const Color(0xFF5D4037);
  final Color darkTextColor = const Color(0xFFE6D7B9);
  
  // Icon colors
  final Color lightIconColor = Colors.black87;
  final Color darkIconColor = Colors.white70;
  
  // Game colors (theme independent)
  final Color correctColor = const Color(0xFF317039);
  final Color misplacedColor = const Color(0xFFF1BE49);
  final Color incorrectColor = const Color(0xFFCC4B24);
  
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