import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/screens/schedule_screen.dart';
import 'package:schedule_app/widgets/appointment_widget.dart';
import 'package:schedule_app/widgets/circular_avatar_button.dart';
import 'package:schedule_app/widgets/person_header_widget.dart';
import 'package:schedule_app/widgets/schedule_table.dart';
import 'package:schedule_app/models/appointment.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Appointment> appointments = [
    Appointment('Мастер 1', 'Клиент 1', TimeOfDay(hour: 9, minute: 0),
        Duration(minutes: 45)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
    Appointment('Мастер 1', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ScheduleApp'),
          actions: [
            const SizedBox(
              width: 8,
            ),
            MasterHeaderWidget(
              title: 'Мастер 1',
              child: Icon(Icons.person),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none_outlined)),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ваши следующие приемы на сегодня:',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  for (var appointment in appointments)
                    AppointmentWidget(
                      height: 100,
                      appointment: Appointment(
                          appointment.master,
                          appointment.client,
                          appointment.startTime,
                          appointment.duration),
                    ),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => ScheduleScreen()));
                  },
                  child: const Text('Полное расписание')),
            )
          ],
        ));
  }
}
