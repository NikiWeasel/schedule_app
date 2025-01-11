import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/fetch_regulations_bloc.dart';
import 'package:schedule_app/core/widgets/alert_confirm_dialog.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/schedule/view/widgets/editing_dialog/editing_dialog.dart';
import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/regulation.dart';

import 'package:schedule_app/core/utils/functions.dart';

class OnHoldDialog extends StatelessWidget {
  OnHoldDialog({
    super.key,
    required this.appointment,
    required this.curentDate,
    required this.deleteAppoTable,
    required this.editAppoTable,
  });

  final Appointment appointment;
  final DateTime curentDate;
  final void Function(Appointment appo) deleteAppoTable;
  final void Function({Appointment? oldAppo, required Appointment newAppo})
      editAppoTable;

  void onEdit(
      BuildContext context, Appointment appointment, List<Regulation> regList) {
    Navigator.pop(context);

    Map<String, int> services = regToServicesList(regList);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return EditingDialog(
            curentDate: curentDate,
            appointment: appointment,
            editAppoTable: editAppoTable,
            employees: null,
            services: services,
          );
        });
  }

  void onDelete(BuildContext context, void Function() deleteAppointment) {
    showDialog(
        context: context,
        builder: (ctx) => AlertConfirmDialog(
            title: 'Отменить запись?',
            content: 'Запись будет удалена навсегда.',
            onConfirm: () {
              deleteAppointment();
              deleteAppoTable(appointment);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<FetchRegulationsBloc, FetchRegulationsState>(
        builder: (context, regulationsState) {
          // return Builder(builder: (context) {
          if (regulationsState is FetchRegulationsLoadedState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onEdit(
                          context, appointment, regulationsState.regulations);
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
                        context.read<ActionsAppointmentBloc>().add(
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
          }
          return const Center(child: CardCircularProgressIndicator());
          // );
        },
      ),
    );
  }
}
