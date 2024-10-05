import 'package:flutter/material.dart';
import 'package:schedule_app/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 0, 165, 115),
  ),
  textTheme: GoogleFonts.rubikTextTheme(),

);


void main() {
  Widget currentScreen = const LoginScreen();

  WidgetsFlutterBinding.ensureInitialized();


  runApp(MaterialApp(
      theme: theme,
      home: currentScreen));
}

