import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/features/authentication/view/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:schedule_app/features/home/view/home_screen.dart';
import 'package:schedule_app/features/authentication/view/splash_screen.dart';
import 'firebase_options.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    theme: theme,
    home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    ),
  ));
}
