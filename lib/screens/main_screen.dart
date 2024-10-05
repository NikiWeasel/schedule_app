import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/circular_avatar_button.dart';
import 'package:schedule_app/widgets/schedule_table.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScheduleApp'),

        actions: [
          CircularAvatarButton(onTap: (){}),
          SizedBox(width: 8,)
        ],

      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(child: ScheduleTable())),
      ),
    );
  }
}