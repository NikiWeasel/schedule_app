import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/core/utils/functions.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/schedule/bloc/local_employees_bloc.dart';
import 'package:schedule_app/features/schedule/view/widgets/editing_dialog/editing_dialog.dart';
import 'package:schedule_app/features/schedule/view/widgets/schedule_table.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({
    super.key,
    required this.user,
    required this.showDialogImmediately,
  });

  final Employee user;
  final bool showDialogImmediately;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime currentDate = DateTime.now();

  bool wasDialogCalled = false;

  void openCreateNewDialog(
      List<Employee> employees, Employee user, List<Regulation> regList) {
    Map<String, int> services = regToServicesList(regList);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return EditingDialog(
            currentDate: currentDate,
            appointment: null,
            employees: user.isAdmin ? employees : null,
            services: services,
          );
        });
  }

  void chooseDate() async {
    var pickedDate = (await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        )) ??
        DateTime.now();

    setState(() {
      currentDate = pickedDate;
    });
  }

  String formatDate(DateTime pickedDate) {
    return DateFormat('d MMMM yyyy', 'ru').format(pickedDate);
  }

  void renew() {
    context.read<LocalEmployeesBloc>().add(FetchAllEmployeesData());
    // context.read<LocalAppointmentsBloc>().add(FetchAppointmentsData());
    context.read<LocalRegulationsBloc>().add(FetchRegulationsData());
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.value);
    return BlocListener<ActionsAppointmentBloc, ActionsAppointmentState>(
      listener: (context, state) {
        if (state is ActionsAppointmentLoadingState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Загрузка...',
              duration: const Duration(seconds: 60));
        }
        if (state is ActionsAppointmentLoadedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Запись сделана!');

          // context
          //     .read<LocalAppointmentsBloc>()
          //     .add(AddLocalAppointment(appointment: state.appo));
        }
        if (state is ActionsAppointmentUpdatedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Запись обновлена!');

          // context
          //     .read<LocalAppointmentsBloc>()
          //     .add(UpdateLocalAppointment(appointment: state.appo));
        }
        if (state is ActionsAppointmentDeletedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Запись удалена!');

          // context
          //     .read<LocalAppointmentsBloc>()
          //     .add(DeleteLocalAppointment(appointment: state.appos.single));
        }

        if (state is ActionsAppointmentErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Произошла ошибка: ${state.error}');
        }
      },
      child: BlocBuilder<LocalEmployeesBloc, LocalEmployeesState>(
        builder: (context, allEmployeesState) {
          return BlocBuilder<LocalRegulationsBloc, FetchRegulationsState>(
            builder: (context, regulationsState) {
              return BlocBuilder<LocalAppointmentsBloc, LocalAppointmentsState>(
                builder: (context, allAppontmentsState) {
                  if ((allEmployeesState is LocalEmployeesLoaded &&
                      allAppontmentsState is LocalAppointmentsLoaded &&
                      regulationsState is LocalRegulationsLoadedState)) {
                    var allMasters = allEmployeesState.employees;
                    var masters = allMasters
                        .where((e) => widget.user.employeeId != e.employeeId)
                        .toList();
                    masters.insert(0, widget.user);

                    if (widget.showDialogImmediately && !wasDialogCalled) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        openCreateNewDialog(
                            masters, widget.user, regulationsState.regulations);
                        wasDialogCalled = true;
                      });
                    }

                    return Scaffold(
                      appBar: AppBar(
                        title: Text(formatDate(currentDate)),
                        actions: [
                          IconButton(
                              onPressed: chooseDate,
                              icon: const Icon(Icons.calendar_month_rounded)),
                          IconButton(
                            icon: const Icon(Icons.autorenew),
                            onPressed: () {
                              renew();
                              print('renewed');
                            },
                          ),
                        ],
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          openCreateNewDialog(masters, widget.user,
                              regulationsState.regulations);
                        },
                        child: const Icon(Icons.add),
                      ),
                      body: ScheduleTable(
                        currentDate: currentDate,
                        allEmployees: masters,
                        allAppointments: allAppontmentsState.appointments,
                      ),
                    );
                  }
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Загрузка...'),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.add),
                    ),
                    body: const Center(
                      child: CardCircularProgressIndicator(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
