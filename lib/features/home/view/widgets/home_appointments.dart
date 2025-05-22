import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/widgets/appointment_widget.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/home/view/widgets/no_appointments_widget.dart';

class HomeAppointments extends StatefulWidget {
  const HomeAppointments(
      {super.key, required this.emlpoyee, required this.appointmentsState});

  final Employee emlpoyee;
  final LocalAppointmentsState appointmentsState;

  @override
  State<HomeAppointments> createState() => _HomeAppointmentsState();
}

class _HomeAppointmentsState extends State<HomeAppointments> {
  List<Appointment> getUpcomingAppointments(
      List<Appointment> allAppointments, DateTime currentDateTime) {
    return allAppointments
        .where((appointment) =>
            appointment.date.isAtSameMomentAs(currentDateTime) ||
            appointment.date.isAfter(currentDateTime))
        .toList();
  }

  List<Appointment> sortAppointments(List<Appointment> appointments) {
    return appointments
        .where((a) => a.masterId == widget.emlpoyee.employeeId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appointmentsState is LocalAppointmentsLoading) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: CardCircularProgressIndicator(),
      ));
    }
    if (widget.appointmentsState is LocalAppointmentsError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
            child: Text(
          'Error: ${(widget.appointmentsState as LocalAppointmentsError).errorMessage}',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.error),
        )),
      );
    }

    if (widget.appointmentsState is LocalAppointmentsLoaded) {
      DateTime currentDate = DateTime.now();
      var appointments = (widget.appointmentsState as LocalAppointmentsLoaded)
          .appointments
          .where((appo) => (appo.date.year == currentDate.year &&
              appo.date.month == currentDate.month &&
              appo.date.day == currentDate.day))
          .toList();

      appointments = getUpcomingAppointments(appointments, currentDate);

      var sortedAppointments = sortAppointments(appointments);
      if (sortedAppointments.isEmpty) {
        return NoAppointmentsWidget(onTap: () {
          context.push('/schedule',
              extra: {'user': widget.emlpoyee, 'showDialogImmediately': true});
        });
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 8)),
            for (var appointment in sortedAppointments)
              AppointmentWidget(
                height: 100,
                appointment: Appointment(
                    clientName: appointment.clientName,
                    clientNumber: appointment.clientNumber,
                    duration: appointment.duration,
                    masterId: appointment.masterId,
                    appointmentId: appointment.appointmentId,
                    serviceName: appointment.serviceName,
                    date: appointment.date),
                onHold: (appo) {},
                onTap: (appo) {},
                width: 200,
              ),
            const Padding(padding: EdgeInsets.only(left: 8)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: IconButton(
                onPressed: () {
                  context.push('/schedule', extra: {
                    'user': widget.emlpoyee,
                    'showDialogImmediately': false
                  });
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (ctx) => ScheduleScreen(
                  //           user: widget.emlpoyee,
                  //           showDialogImidiatly: true,
                  //         )));
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
