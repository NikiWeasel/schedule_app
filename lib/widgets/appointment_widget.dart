import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/schedule_table.dart';
import 'package:schedule_app/models/appointment.dart';


class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget(
      {super.key, required this.height, required this.appointment});

  final double height;
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onLongPress: () {},
      child: Container(
        margin: const EdgeInsets.all(4.0),
        height: height,
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${appointment.duration.inMinutes} мин -- ${appointment.startTime.format(context)}-${appointment.startTime.hour + appointment.duration.inHours}'),
              Text('${appointment.client}'),
            ],
          ),
        ),
      ),
    );
  }
}
