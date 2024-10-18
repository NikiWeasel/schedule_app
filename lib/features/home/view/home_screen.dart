import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/widgets/loading_skeleton.dart';
import 'package:schedule_app/core/widgets/splash_screen.dart';
import 'package:schedule_app/features/notifications/view/notifications_screen.dart';
import 'package:schedule_app/features/schedule/view/schedule_screen.dart';
import 'package:schedule_app/core/widgets/appointment_widget.dart';
import 'package:schedule_app/features/home/view/widgets/home_screen_drawer.dart';
import 'package:schedule_app/core/widgets/person_header_widget.dart';
import 'package:schedule_app/features/schedule/view/widgets/schedule_table.dart';
import 'package:schedule_app/models/appointment.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Appointment> appointments = [
    Appointment('Мастер 1', 'Клиент 1', TimeOfDay(hour: 9, minute: 0),
        Duration(minutes: 45)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        print(state);
        if (state is UserError) {
          // ScaffoldMessenger.of(context).clearSnackBars();
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          print(state.errorMessage);

          return const SplashScreen();
        }
        if (state is UserLoaded) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('ScheduleApp'),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const NotificationsScreen()));
                      },
                      icon: Badge(
                        label: Text(
                          '12',
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: const Icon(Icons.notifications_none_outlined),
                      )),
                  const SizedBox(
                    width: 8,
                  )
                ],
              ),
              drawer: HomeScreenDrawer(
                employee: state.user,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Ваши следующие приемы на сегодня:',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 8)),
                        for (var appointment in appointments)
                          AppointmentWidget(
                            height: 100,
                            appointment: Appointment(
                                appointment.master,
                                appointment.client,
                                appointment.startTime,
                                appointment.duration),
                            onHold: () {},
                          ),
                        const Padding(padding: EdgeInsets.only(left: 8)),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const ScheduleScreen()));
                        },
                        child: const Text('Полное расписание')),
                  ),
                  // LoadingSkeleton(
                  //   child: AppointmentWidget(
                  //     height: 100,
                  //     appointment: Appointment(
                  //         appointments[0].master,
                  //         appointments[0].client,
                  //         appointments[0].startTime,
                  //         appointments[0].duration),
                  //     onHold: () {},
                  //   ),
                  // ),
                ],
              ));
        }
        return const SplashScreen();
      },
    );
  }
}
