import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/core/bloc/fetch_appointments//fetch_appointments_bloc.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/widgets/appointment_widget.dart';
import 'package:schedule_app/features/home/view/widgets/no_appointments_widget.dart';

import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/schedule/view/schedule_screen.dart';

import 'package:schedule_app/core/models/employee.dart';

class HomeAppointments extends StatefulWidget {
  const HomeAppointments(
      {super.key, required this.emlpoyee, required this.appointmentsState});

  final Employee emlpoyee;
  final FetchAppointmentsState appointmentsState;

  @override
  State<HomeAppointments> createState() => _HomeAppointmentsState();
}

class _HomeAppointmentsState extends State<HomeAppointments> {
  List<Appointment> sortAppointments(List<Appointment> appointments) {
    return appointments
        .where((a) => a.masterId == widget.emlpoyee.employeeId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appointmentsState is FetchAppointmentsLoading) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: CardCircularProgressIndicator(),
      ));
    }
    if (widget.appointmentsState is FetchAppointmentsError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
            child: Text(
          'Error: ${(widget.appointmentsState as FetchAppointmentsError).errorMessage}',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.error),
        )),
      );
    }

    if (widget.appointmentsState is FetchAppointmentsLoaded) {
      DateTime curentDate = DateTime.now();
      var appointments = (widget.appointmentsState as FetchAppointmentsLoaded)
          .appointments
          .where((appo) => (appo.date.year == curentDate.year &&
              appo.date.month == curentDate.month &&
              appo.date.day == curentDate.day))
          .toList();
      var sortedAppointments = sortAppointments(appointments);
      if (sortedAppointments.isEmpty) {
        return NoAppointmentsWidget(onTap: () {
          context.push('/schedule',
              extra: {'user': widget.emlpoyee, 'showDialogImidiatly': true});
        });
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 8)),
            for (var appointment in sortedAppointments)
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                ),
                child: AppointmentWidget(
                  height: 100,
                  appointment: Appointment(
                      clientName: appointment.clientName,
                      clientNumber: appointment.clientNumber,
                      startTime: appointment.startTime,
                      duration: appointment.duration,
                      masterId: appointment.masterId,
                      appointmentId: appointment.appointmentId,
                      serviceName: appointment.serviceName,
                      date: appointment.date),
                  onHold: (appo) {},
                  onTap: (appo) {},
                ),
              ),
            const Padding(padding: EdgeInsets.only(left: 8)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ScheduleScreen(
                            user: widget.emlpoyee,
                            showDialogImidiatly: true,
                          )));
                },
                icon: const Icon(Icons.add),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 8)),
          ],
        ),
      );
    }
    return NoAppointmentsWidget(onTap: () {});
  }
}
