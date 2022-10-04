import 'package:flutter/material.dart';

Color colorPrimary = Colors.lightGreen.shade800;
Color colorAccent = Colors.greenAccent.shade700;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: colorPrimary,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorAccent,
  )
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);