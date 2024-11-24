import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/features/schedule/view/widgets/schedule_table.dart';
import 'package:schedule_app/core/models/appointment.dart';

class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget(
      {super.key,
      required this.height,
      required this.appointment,
      required this.onTap,
      required this.onHold});

  final double height;
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
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${appointment.getFormattedStartTime()} — ${appointment.getFormattedEndTime()}   ${appointment.getFormattedDuration()}',
                overflow: TextOverflow.fade,
              ),
              height >= 60
                  ? Text(
                      '${appointment.clientName} ${appointment.clientNumber} \n${appointment.serviceName}',
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                    )
                  : Text(
                      '${appointment.clientName} ${appointment.clientNumber} ${appointment.serviceName}',
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
              // Text(appointment.clientNumber, overflow: TextOverflow.fade),
              // Text(appointment.serviceName, overflow: TextOverflow.fade),
            ],
          ),
        ),
      ),
    );
  }
}
