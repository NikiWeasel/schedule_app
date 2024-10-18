import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/circular_avatar_button.dart';
import 'package:schedule_app/widgets/schedule_table.dart';
import 'package:schedule_app/widgets/appointment_dialog/editing_dialog.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  void openCreateNewDialog() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => const EditingDialog(
              isEditing: false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        actions: [
          IconButton(
            icon: const Icon(Icons.autorenew),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateNewDialog,
        child: const Icon(Icons.add),
      ),
      body: const SingleChildScrollView(
        child: IntrinsicHeight(child: ScheduleTable()),
      ),
    );
  }
}
