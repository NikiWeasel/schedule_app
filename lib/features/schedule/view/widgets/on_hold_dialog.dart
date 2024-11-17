import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/features/schedule/view/widgets/editing_dialog.dart';
import 'package:schedule_app/core/bloc/add_delete/actions_appointment_bloc.dart';
import 'package:schedule_app/core/models/appointment.dart';

class OnHoldDialog extends StatelessWidget {
  OnHoldDialog(
      {super.key, required this.appointment, required this.curentDate});

  final Appointment appointment;
  final DateTime curentDate;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void onEdit(BuildContext context, Appointment appointment) {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => EditingDialog(
              curentDate: curentDate,
              appointment: appointment,
            ));
  }

  void onDelete(BuildContext context, void Function() deleteAppointment) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                'Отменить запись?',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
              content: Text(
                'Запись будет удалена навсегда.',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              actionsAlignment: MainAxisAlignment.start,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      deleteAppointment();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Подтвердить')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.of(context).pop();
                    },
                    child: const Text('Отмена'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (context) => ActionsAppointmentBloc(_firebaseFirestore),
        child: Builder(builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onEdit(context, appointment);
                  },
                  child: Text(
                    'Редактировать запись',
                    style: Theme.of(context).textTheme.titleMedium!,
                  ),
                  // style: ElevatedButtonTheme.of(context).style!.copyWith(backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onDelete(context, () {
                      BlocProvider.of<ActionsAppointmentBloc>(context).add(
                          DeleteAppointmentEvent(appointment: appointment));
                    });
                  },
                  child: Text(
                    'Отменить запись',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
