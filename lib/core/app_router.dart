import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/widgets/splash_screen.dart';
import 'package:schedule_app/features/authentication/view/login_screen.dart';
import 'package:schedule_app/features/home/view/home_screen.dart';
import 'package:schedule_app/features/notifications/view/notifications_screen.dart';
import 'package:schedule_app/features/portfolio/view/portfolio_screen.dart';
import 'package:schedule_app/features/regulations/view/regulations_screen.dart';
import 'package:schedule_app/features/schedule/view/schedule_screen.dart';
import 'package:schedule_app/app.dart';
import 'package:schedule_app/features/settings/view/settings_screen.dart';
import 'package:schedule_app/features/profile/view/profile_screen.dart';
import 'package:schedule_app/root_screen.dart';
import 'bloc/actions_appointments/actions_appointment_bloc.dart';

class AppRouter {
  static bool redirected = false;

  static bool hideNavigationBar = false;

  static get router {
    return GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/schedule',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>?;
            print('router. ${context.read<ActionsAppointmentBloc>()}');
            return ScheduleScreen(
              user: data?['user'],
              showDialogImidiatly: data?['showDialogImidiatly'],
            );
          },
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) {
            return const NotificationsScreen();
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) {
            return const SettingsScreen();
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: '/app',
          builder: (context, state) {
            return const App();
          },
        ),
        GoRoute(
          path: '/splash',
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        // BottomNavigationBar
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            // final hideNavigationBar = state.extra as bool? ?? false;

            return RootScreen(
              navigationShell: navigationShell,
              hideNavigationBar: hideNavigationBar,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/regulations',
                  builder: (context, state) {
                    return const RegulationsScreen();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/portfolio',
                  builder: (context, state) => const PortfolioScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                    path: '/profile',
                    builder: (context, state) {
                      return const ProfileScreen();
                    }),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null && state.path != '/app') {
          return '/app';
        }
        return null;
      },
    );
  }
}
