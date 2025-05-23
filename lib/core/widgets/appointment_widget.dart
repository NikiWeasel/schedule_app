import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/appointment.dart';

class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget(
      {super.key,
      required this.height,
      required this.appointment,
      required this.onTap,
      required this.onHold,
      required this.width});

  final double height;
  final double width;
  final Appointment appointment;
  final void Function(Appointment appointment) onHold;
  final void Function(Appointment appointment) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onLongPress: () {
        onHold(appointment);
      },
      onTap: () {
        onTap(appointment);
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: height >= 60
              ? Text(
                  '${appointment.getFormattedStartTime()} — ${appointment.getFormattedEndTime()}   ${appointment.getFormattedDuration()}\n${appointment.clientName}\n${appointment.clientNumber} \n${appointment.serviceName}',
                  overflow: TextOverflow.fade,
                  maxLines: 4,
                )
              : Text(
                  '${appointment.getFormattedStartTime()} — ${appointment.getFormattedEndTime()}   ${appointment.getFormattedDuration()}\n${appointment.clientName} ${appointment.clientNumber} ${appointment.serviceName}',
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                ),
        ),
      ),
    );
  }
}
