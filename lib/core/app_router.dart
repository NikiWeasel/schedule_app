import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/features/home/view/home_screen.dart';
import 'package:schedule_app/features/notifications/view/notifications_screen.dart';
import 'package:schedule_app/features/schedule/view/schedule_screen.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        // GoRoute(
        //   path: 'schedule_screen',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const ScheduleScreen(user: user);
        //   },
        // ),
        // GoRoute(
        //   path: 'details',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const DetailsScreen();
        //   },
        // ),
        GoRoute(
          path: '/schedule_screen',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>?;
            return ScheduleScreen(
              user: data?['user'],
              showDialogImidiatly: data?['showDialogImidiatly'],
            );
          },
        ),
        GoRoute(
          path: '/notifications_screen',
          builder: (context, state) {
            // final data = state.extra as Map<String, dynamic>?;
            return const NotificationsScreen();
          },
        ),
      ],
    ),
  ],
);
