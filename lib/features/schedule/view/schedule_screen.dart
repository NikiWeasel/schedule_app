import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/add_delete/actions_appointment_bloc.dart';
import 'package:schedule_app/features/schedule/view/widgets/schedule_table.dart';
import 'package:schedule_app/features/schedule/view/widgets/editing_dialog.dart';

import 'package:schedule_app/core/bloc/fetch/fetch_appointments_bloc.dart';
import 'package:schedule_app/features/schedule/bloc/all_employees_bloc.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void openCreateNewDialog() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => EditingDialog(
              appointment: null,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        actions: [
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
      body: const ScheduleTable(),
    );
  }
}
