import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/appointments_bloc.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/widgets/appointment_widget.dart';

class HomeAppointments extends StatefulWidget {
  const HomeAppointments({super.key});

  @override
  State<HomeAppointments> createState() => _HomeAppointmentsState();
}

class _HomeAppointmentsState extends State<HomeAppointments> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentsBloc(),
      child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
        builder: (ctx, state) {
          if (state is AppointmentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AppointmentsError) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                  child: Text(
                'Error: ${state.errorMessage}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              )),
            );
          }

          if (state is AppointmentsLoaded) {
            var appointments = state.appointments;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  for (var appointment in appointments)
                    AppointmentWidget(
                      height: 100,
                      appointment: Appointment(
                          master: appointment.master,
                          client: appointment.client,
                          startTime: appointment.startTime,
                          duration: appointment.duration),
                      onHold: () {},
                    ),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
                child: Text('Нет данных',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error))),
          );
        },
      ),
    );
  }
}
