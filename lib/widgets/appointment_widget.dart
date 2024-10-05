import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/schedule_table.dart';


class AppointmentWidget extends StatelessWidget{
  const AppointmentWidget({super.key, required this.height, required this.appointment});

  final double height;
  final Appointment appointment;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: (){},
      child: Container(
        margin: EdgeInsets.all(4.0),
        height: height,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),

        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${appointment.duration.inMinutes} мин'),
              Text('${appointment.client}'),
            ],
          ),
        ),
      ),
    );
  }
}