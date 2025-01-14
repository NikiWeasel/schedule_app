import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/features/home/view/widgets/old_appos_bottom_sheet.dart';
import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';

DateTime _subtractMonths(DateTime date, int months) {
  int newYear = date.year;
  int newMonth = date.month - months;

  while (newMonth <= 0) {
    newYear -= 1;
    newMonth += 12;
  }

  // Убедитесь, что день корректный для нового месяца
  int newDay = date.day;
  int daysInNewMonth =
      DateTime(newYear, newMonth + 1, 0).day; // Последний день нового месяца
  if (newDay > daysInNewMonth) {
    newDay = daysInNewMonth;
  }

  return DateTime(newYear, newMonth, newDay, date.hour, date.minute,
      date.second, date.millisecond, date.microsecond);
}

List<Appointment> _getOldAppos(
    {required List<Appointment> apposList, required int monthsOldToDelete}) {
  var date = DateTime.now();
  var oldDate = _subtractMonths(date, monthsOldToDelete);

  return apposList
      .where(
        (element) => element.date.isBefore(oldDate),
      )
      .toList();
}

void deleteOldAppos(
    {required bool isAdmin,
    required List<Appointment> apposList,
    required int monthsOldToDelete,
    required bool deleteWithoutAsking,
    required BuildContext context}) {
  var date = DateTime.now();
  var oldAppos =
      _getOldAppos(apposList: apposList, monthsOldToDelete: monthsOldToDelete);

  if (date.day != 1 || !isAdmin || oldAppos.isEmpty) return;

  if (deleteWithoutAsking) {
    context.read<ActionsAppointmentBloc>().add(
          DeleteAllAppointmentsEvent(appointments: oldAppos),
        );

    print('DELETED ALL withoutAsking');
  } else {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => OldApposBottomSheet(
              oldAppos: oldAppos,
              onDeleteAllAppos: () {
                context
                    .read<ActionsAppointmentBloc>()
                    .add(DeleteAllAppointmentsEvent(appointments: oldAppos));
                print('DELETED ALL');
              },
              monthsOldToDelete: monthsOldToDelete,
            ));
  }
}
