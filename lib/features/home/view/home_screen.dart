import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/core/bloc/fetch_appointments//fetch_appointments_bloc.dart';
import 'package:schedule_app/core/widgets/loading_skeleton.dart';
import 'package:schedule_app/core/widgets/splash_screen.dart';
import 'package:schedule_app/features/home/view/widgets/home_appointments.dart';
import 'package:schedule_app/features/home/view/widgets/home_line_chart.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/features/schedule/bloc/all_employees_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isShowingMainData = true;

  int currentPageIndex = 0;

  void renew() {
    //TODO мб засунуть еще для UserBloc
    context.read<AllEmployeesBloc>().add(FetchAllEmployeesData());
    context.read<FetchAppointmentsBloc>().add(FetchAppointmentsData());
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(userState.error)),
                    );
                  });
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
                                renew();
                              },
                              icon: const Icon(Icons.autorenew)),
                          IconButton(
                              onPressed: () {
                                context.push('/notifications');
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
                              emlpoyee: userState.user,
                              appointmentsState: allAppontmentsState,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                  onPressed: () {
                                    context.push('/schedule', extra: {
                                      'user': userState.user,
                                      'showDialogImidiatly': false
                                    });
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
