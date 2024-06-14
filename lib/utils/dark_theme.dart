import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.blueGrey,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    color: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
    headlineLarge: TextStyle(color: Colors.white, fontSize: 24),
    titleLarge: TextStyle(color: Colors.white, fontSize: 20),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blueAccent,
    textTheme: ButtonTextTheme.primary,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent),
    ),
    labelStyle: TextStyle(color: Colors.blueAccent),
  ),
);
