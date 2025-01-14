import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getTheme(int seedColor) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Color(seedColor),
    ),
    textTheme: GoogleFonts.rubikTextTheme(),
  );
}

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 154, 0, 165),
  ),
  textTheme: GoogleFonts.rubikTextTheme(),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ButtonStyle(
  //       backgroundColor: WidgetStateProperty.all<Color>(
  //           Color.fromARGB(255, 236, 200, 200)),
  //       foregroundColor: WidgetStateProperty.all<Color>(Colors.white)),
  // )
);
