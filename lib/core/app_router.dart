import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/core/widgets/splash_screen.dart';
import 'package:schedule_app/features/home/view/home_screen.dart';
import 'package:schedule_app/features/notifications/view/notifications_screen.dart';
import 'package:schedule_app/features/portfolio/view/portfolio_screen.dart';
import 'package:schedule_app/features/regulations/view/regulations_screen.dart';
import 'package:schedule_app/features/schedule/view/schedule_screen.dart';
import 'package:schedule_app/app.dart';
import 'package:schedule_app/features/settings/view/settings_screen.dart';
import 'package:schedule_app/features/profile/view/profile_screen.dart';
import 'package:schedule_app/root_screen.dart';

//         GoRoute(
//           path: '/schedule',
//           builder: (context, state) {
//             final data = state.extra as Map<String, dynamic>?;
//             return ScheduleScreen(
//               user: data?['user'],
//               showDialogImidiatly: data?['showDialogImidiatly'],
//             );
//           },

final router = GoRouter(
  initialLocation: '/app',
  routes: [
    GoRoute(
      path: '/schedule',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
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
    // BottomNavigationBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        final hideNavigationBar = state.extra as bool? ?? false;

        return RootScreen(
          navigationShell: navigationShell,
          hideNavigationBar: hideNavigationBar,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/app',
              builder: (context, state) => const App(),
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
);
