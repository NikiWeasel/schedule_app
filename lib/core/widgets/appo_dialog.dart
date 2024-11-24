import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/appointment.dart';

class AppoDialog extends StatelessWidget {
  const AppoDialog({super.key, required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${appointment.getFormattedStartTime()} — ${appointment.getFormattedEndTime()}   ${appointment.getFormattedDuration()}',
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            '${appointment.clientName} ${appointment.clientNumber} \n${appointment.serviceName}',
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 2,
          )
          // Text(appointment.clientNumber, overflow: TextOverflow.fade),
          // Text(appointment.serviceName, overflow: TextOverflow.fade),
        ],
      ),
      actions: [],
    );
  }
}
