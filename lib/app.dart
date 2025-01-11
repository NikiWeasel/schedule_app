import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/app_router.dart';
import 'core/bloc/fetch_appointments/fetch_appointments_bloc.dart';
import 'core/widgets/splash_screen.dart';
import 'features/authentication/view/login_screen.dart';
import 'features/home/bloc/user_bloc.dart';
import 'features/home/view/home_screen.dart';
import 'features/schedule/bloc/all_employees_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool loggedin = false;

  void login() {
    if (!loggedin) {
      context.go('/home');
      loggedin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            login();
          });
        }
        return const LoginScreen();
      },
    );
  }
}
