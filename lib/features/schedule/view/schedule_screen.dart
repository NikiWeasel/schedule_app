import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/core/bloc/add_delete/actions_appointment_bloc.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/features/schedule/view/widgets/schedule_table.dart';
import 'package:schedule_app/features/schedule/view/widgets/editing_dialog.dart';

import 'package:schedule_app/core/bloc/fetch/fetch_appointments_bloc.dart';
import 'package:schedule_app/features/schedule/bloc/all_employees_bloc.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, required this.user});

  final Employee user;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime currentDate = DateTime.now();

  // dateString

  void openCreateNewDialog() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => EditingDialog(
              appointment: null,
            ));
  }

  void chooseDate() async {
    var pickedDate = (await showDatePicker(
          context: context,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        )) ??
        DateTime.now();

    setState(() {
      currentDate = pickedDate;
    });
    // dateString = DateFormat('yMMMMEEEEd', 'ru').format(pickedDate!);
  }

  String formatDate(DateTime pickedDate) {
    return DateFormat('d MMMM', 'ru').format(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formatDate(currentDate)),
        actions: [
          IconButton(
              onPressed: chooseDate,
              icon: const Icon(Icons.calendar_month_rounded)),
          MultiBlocProvider(
            providers: [
              BlocProvider<AllEmployeesBloc>(
                create: (context) => AllEmployeesBloc(),
              ),
              BlocProvider<FetchAppointmentsBloc>(
                create: (context) => FetchAppointmentsBloc(),
              ),
            ],
            child: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.autorenew),
                onPressed: () {
                  context.read<AllEmployeesBloc>().add(FetchAllEmployeesData());
                  context
                      .read<FetchAppointmentsBloc>()
                      .add(FetchAppointmentsData());
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateNewDialog,
        child: const Icon(Icons.add),
      ),
      body: ScheduleTable(
        user: widget.user,
        curentDate: currentDate,
      ),
    );
  }
}
