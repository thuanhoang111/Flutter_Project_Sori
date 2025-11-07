import 'package:flutter/material.dart';

class Constants {
  static const String appName = "Flutter_Project_Sori";

  // 🌕 Màu sắc cho theme
  static const Color lightPrimary = Color(0xfffcfcff);
  static const Color darkPrimary = Colors.black;
  static const Color lightAccent = Color(0xff5563ff);
  static const Color darkAccent = Color(0xff5563ff);
  static const Color lightBG = Color(0xfffcfcff);
  static const Color darkBG = Colors.black;
  static final Color ratingBG = Colors.yellow.shade600;

  // 🌤️ Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBG,
    primaryColor: lightPrimary,
    colorScheme: ColorScheme.light(
      primary: lightAccent,
      secondary: lightAccent,
      background: lightBG,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: darkBG,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(color: darkBG),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: lightAccent,
      selectionColor: Color(0x885563FF),
      selectionHandleColor: lightAccent,
    ),
  );

  // 🌑 Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBG,
    primaryColor: darkPrimary,
    colorScheme: ColorScheme.dark(
      primary: darkAccent,
      secondary: darkAccent,
      background: darkBG,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: lightBG,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(color: lightBG),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: darkAccent,
      selectionColor: Color(0x885563FF),
      selectionHandleColor: darkAccent,
    ),
  );
}
bool isNetworkImage(String? path) {
  final uri = Uri.tryParse(path ?? '');
  return uri?.hasScheme == true && (uri!.scheme == 'http' || uri.scheme == 'https');
}