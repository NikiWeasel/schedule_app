import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/core/utils/old_appo_removal.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:schedule_app/features/home/view/widgets/home_appointments.dart';
import 'package:schedule_app/features/home/view/widgets/home_line_chart.dart';
import 'package:schedule_app/features/schedule/bloc/local_employees_bloc.dart';
import 'package:schedule_app/features/settings/bloc/settings_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isShowingMainData = true;

  int currentPageIndex = 0;

  bool didTryToDeleteAppos = false;

  void renew() {
    //TODO мб засунуть еще для UserBloc
    context.read<LocalEmployeesBloc>().add(FetchAllEmployeesData());
    context.read<LocalAppointmentsBloc>().add(FetchAppointmentsData());
  }

  @override
  Widget build(BuildContext rootContext) {
    return BlocBuilder<LocalRegulationsBloc, FetchRegulationsState>(
      builder: (context, regulationsState) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return BlocBuilder<LocalAppointmentsBloc, LocalAppointmentsState>(
              builder: (context1, allAppontmentsState) {
                return BlocBuilder<LocalEmployeesBloc, LocalEmployeesState>(
                  builder: (context2, allEmployeesState) {
                    return BlocBuilder<UserBloc, UserState>(
                      builder: (context3, userState) {
                        if (userState is UserError) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(rootContext).clearSnackBars();
                            ScaffoldMessenger.of(rootContext).showSnackBar(
                              SnackBar(content: Text(userState.error)),
                            );
                          });
                          debugPrint(userState.error);

                          return const Center(
                            child: CardCircularProgressIndicator(),
                          );
                        }
                        if (userState is UserLoaded) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!didTryToDeleteAppos &&
                                allAppontmentsState
                                    is LocalAppointmentsLoaded &&
                                settingsState is SettingsLoaded) {
                              didTryToDeleteAppos = true;
                              deleteOldAppos(
                                isAdmin: userState.user.isAdmin,
                                apposList: allAppontmentsState.appointments,
                                settings: settingsState.settings,
                                context: context,
                              );
                              renew();
                            }
                          });

                          return Scaffold(
                              appBar: AppBar(
                                title: const Text('Vteme'),
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                        rootContext.push('/notifications');
                                      },
                                      icon: Badge(
                                        label: Text(
                                          '12',
                                          style: Theme.of(rootContext)
                                              .textTheme
                                              .bodySmall!,
                                        ),
                                        backgroundColor: Theme.of(rootContext)
                                            .colorScheme
                                            .primaryContainer,
                                        child: const Icon(
                                            Icons.notifications_none_outlined),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        renew();
                                      },
                                      icon: const Icon(Icons.autorenew)),
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
                                        style: Theme.of(rootContext)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
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
                                            print(
                                                '1. ${context.read<ActionsAppointmentBloc>()}');
                                            print(
                                                '2. ${rootContext.read<ActionsAppointmentBloc>()}');
                                            print(context1.read<
                                                ActionsAppointmentBloc>());

                                            rootContext.push('/schedule',
                                                extra: {
                                                  'user': userState.user,
                                                  'showDialogImmediately': false
                                                });
                                          },
                                          child:
                                              const Text('Полное расписание')),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Статистика:',
                                        style: Theme.of(rootContext)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: (allAppontmentsState
                                                    is LocalAppointmentsLoaded &&
                                                allEmployeesState
                                                    is LocalEmployeesLoaded &&
                                                regulationsState
                                                    is LocalRegulationsLoadedState)
                                            ? HomeLineChart(
                                                // key: key,
                                                allAppointments:
                                                    allAppontmentsState
                                                        .appointments,
                                                allEmployees:
                                                    allEmployeesState.employees,
                                                currentEmployeeId:
                                                    userState.user.employeeId,
                                                allRegulations: regulationsState
                                                    .regulations,
                                              )
                                            : Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 48,
                                                  ),
                                                  Container(
                                                    // margin: const EdgeInsets.all(16.0),
                                                    height: 200,
                                                    width: double.infinity,

                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: SizedBox(
                                                          height: 35,
                                                          width: 35,
                                                          child:
                                                              CircularProgressIndicator()),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                  ],
                                ),
                              ));
                        }
                        return const Center(
                          child: CardCircularProgressIndicator(),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
