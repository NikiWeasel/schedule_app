import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/features/home/view/home_screen.dart';
import 'package:schedule_app/features/notifications/view/notifications_screen.dart';
import 'package:schedule_app/features/schedule/view/schedule_screen.dart';
import 'package:schedule_app/app.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const App();
      },
      routes: <RouteBase>[
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
            // final data = state.extra as Map<String, dynamic>?;
            return const NotificationsScreen();
          },
        ),
      ],
    ),
  ],
);
