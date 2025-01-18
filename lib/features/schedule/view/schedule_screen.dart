import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/core/bloc/actions_appointments//actions_appointment_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/fetch_regulations_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/fetch_regulations_bloc.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/features/schedule/view/widgets/schedule_table.dart';
import 'package:schedule_app/features/schedule/view/widgets/editing_dialog/editing_dialog.dart';
import 'package:schedule_app/core/bloc/fetch_appointments/fetch_appointments_bloc.dart';
import 'package:schedule_app/features/schedule/bloc/all_employees_bloc.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/core/utils/functions.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';

import '../../portfolio/bloc/actions_portfolio_photos_bloc.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({
    super.key,
    required this.user,
    required this.showDialogImidiatly,
  });

  final Employee user;
  final bool showDialogImidiatly;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime currentDate = DateTime.now();
  late void Function({Appointment? oldAppo, required Appointment newAppo})
      editAppoTable;

  bool wasDialogCalled = false;

  void openCreateNewDialog(
      List<Employee> employees, Employee user, List<Regulation> regList) {
    Map<String, int> services = regToServicesList(regList);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return EditingDialog(
            curentDate: currentDate,
            appointment: null,
            editAppoTable: (editAppoTable),
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
    context.read<AllEmployeesBloc>().add(FetchAllEmployeesData());
    context.read<FetchAppointmentsBloc>().add(FetchAppointmentsData());
    context.read<FetchRegulationsBloc>().add(FetchRegulationsData());
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.value);
    return BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
      builder: (context, allEmployeesState) {
        return BlocBuilder<FetchRegulationsBloc, FetchRegulationsState>(
          builder: (context, regulationsState) {
            return BlocBuilder<FetchAppointmentsBloc, FetchAppointmentsState>(
              builder: (context, allAppontmentsState) {
                if ((allEmployeesState is AllEmployeesLoaded &&
                    allAppontmentsState is FetchAppointmentsLoaded &&
                    regulationsState is FetchRegulationsLoadedState)) {
                  var allMasters = allEmployeesState.employees;
                  var masters = allMasters
                      .where((e) => widget.user.employeeId != e.employeeId)
                      .toList();
                  masters.insert(0, widget.user);

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
                        openCreateNewDialog(
                            masters, widget.user, regulationsState.regulations);
                      },
                      child: const Icon(Icons.add),
                    ),
                    body: ScheduleTable(
                      curentDate: currentDate,
                      allEmployees: masters,
                      allAppontments: allAppontmentsState.appointments,
                      setEditAppoTable: (callback) {
                        setState(() {
                          editAppoTable = callback;
                        });
                        if (widget.showDialogImidiatly && !wasDialogCalled) {
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                          openCreateNewDialog(masters, widget.user,
                              regulationsState.regulations);
                          setState(() {
                            wasDialogCalled = true;
                          });
                          // });
                        }
                      },
                    ),
                  );
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Text(formatDate(currentDate)),
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.calendar_month_rounded)),
                      IconButton(
                        icon: const Icon(Icons.autorenew),
                        onPressed: () {},
                      ),
                    ],
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
    );
  }
}
