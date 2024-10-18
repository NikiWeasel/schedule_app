import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/widgets/splash_screen.dart';
import 'features/authentication/view/login_screen.dart';
import 'features/home/bloc/user_bloc.dart';
import 'features/home/view/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData) {
          return BlocProvider(
              create: (context) => UserBloc()..add(FetchUserData()),
              child: const HomeScreen());
        }
        return const LoginScreen();
      },
    );
  }
}
