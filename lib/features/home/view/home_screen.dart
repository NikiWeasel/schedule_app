import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/bloc/fetch/fetch_appointments_bloc.dart';
import 'package:schedule_app/core/widgets/loading_skeleton.dart';
import 'package:schedule_app/core/widgets/splash_screen.dart';
import 'package:schedule_app/features/home/view/widgets/home_appointments.dart';
import 'package:schedule_app/features/home/view/widgets/home_line_chart.dart';
import 'package:schedule_app/features/notifications/view/notifications_screen.dart';
import 'package:schedule_app/features/schedule/view/schedule_screen.dart';
import 'package:schedule_app/core/widgets/appointment_widget.dart';
import 'package:schedule_app/features/home/view/widgets/home_screen_drawer.dart';
import 'package:schedule_app/core/widgets/person_header_widget.dart';
import 'package:schedule_app/features/schedule/view/widgets/schedule_table.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/schedule/bloc/all_employees_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var key = UniqueKey();

  bool isShowingMainData = true;

  void renewKey() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchAppointmentsBloc, FetchAppointmentsState>(
      // key: key,
      builder: (context, allAppontmentsState) {
        return BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
          builder: (context, allEmployeesState) {
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserError) {
                  // ScaffoldMessenger.of(context).clearSnackBars();
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text(state.erro
                  //     rMessage)));
                  debugPrint(userState.error);

                  return const SplashScreen();
                }
                if (userState is UserLoaded) {
                  return Scaffold(
                      appBar: AppBar(
                        title: const Text('Vteme'),
                        actions: [
                          IconButton(
                              onPressed: () {
                                context
                                    .read<AllEmployeesBloc>()
                                    .add(FetchAllEmployeesData());
                                context
                                    .read<FetchAppointmentsBloc>()
                                    .add(FetchAppointmentsData());
                                renewKey();
                              },
                              icon: const Icon(Icons.autorenew)),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) =>
                                        const NotificationsScreen()));
                              },
                              icon: Badge(
                                label: Text(
                                  '12',
                                  style: Theme.of(context).textTheme.bodySmall!,
                                ),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: const Icon(
                                    Icons.notifications_none_outlined),
                              )),
                          const SizedBox(
                            width: 8,
                          )
                        ],
                      ),
                      drawer: HomeScreenDrawer(
                        employee: userState.user,
                      ),
                      body: SingleChildScrollView(
                        child: Column(
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
                            HomeAppointments(
                              key: key,
                              emlpoyee: userState.user,
                              appointmentsState: allAppontmentsState,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (ctx) => ScheduleScreen(
                                                  user: userState.user,
                                                  showDialogImidiatly: false,
                                                )));
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Статистика:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: HomeLineChart(
                                // key: key,
                                allAppointmentsState: allAppontmentsState,
                                allEmployeesState: allEmployeesState,
                                currentEmployeeId: userState.user.employeeId,
                              ),
                            ),
                          ],
                        ),
                      ));
                }
                return const SplashScreen();
              },
            );
          },
        );
      },
    );
  }
}
