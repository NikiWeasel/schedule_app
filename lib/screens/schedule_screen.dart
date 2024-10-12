import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/circular_avatar_button.dart';
import 'package:schedule_app/widgets/schedule_table.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),

        // actions: [
        //   CircularAvatarButton(onTap: (){}),
        //   SizedBox(width: 8,)
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      body: const SingleChildScrollView(
        child: IntrinsicHeight(child: ScheduleTable()),
      ),
    );
  }
}
