import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/features/home/view/widgets/old_appos_bottom_sheet.dart';
import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'package:schedule_app/features/settings/bloc/settings_bloc.dart';
import 'package:schedule_app/core/models/settings.dart';

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
    required BuildContext context,
    required UserSettings settings}) {
  var date = DateTime.now();
  var oldAppos = _getOldAppos(
      apposList: apposList, monthsOldToDelete: settings.monthsOldToDelete);

  var removalDateStart = DateTime(date.year, date.month, 1);
  var removalDateEnd = DateTime(date.year, date.month, 7);
  // if (date.day == 28) settings.didAsk = false;
  if (date.isAfter(removalDateEnd) && settings.didAsk) {
    UserSettings newSettings = UserSettings(
        monthsOldToDelete: settings.monthsOldToDelete,
        deleteWithoutAsking: settings.deleteWithoutAsking,
        didAsk: false,
        themeSeed: settings.themeSeed);

    context.read<SettingsBloc>().add(
          UpdateSettings(settings: newSettings),
        );
  }

  if (!((date.isAfter(removalDateStart) && date.isBefore(removalDateEnd)) &&
          !settings.didAsk) ||
      !isAdmin ||
      oldAppos.isEmpty) {
    return;
  }
  UserSettings newSettings = UserSettings(
      monthsOldToDelete: settings.monthsOldToDelete,
      deleteWithoutAsking: settings.deleteWithoutAsking,
      didAsk: true,
      themeSeed: settings.themeSeed);

  if (settings.deleteWithoutAsking) {
    context.read<ActionsAppointmentBloc>().add(
          DeleteAllAppointmentsEvent(appointments: oldAppos),
        );

    context.read<SettingsBloc>().add(
          UpdateSettings(settings: newSettings),
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
              monthsOldToDelete: settings.monthsOldToDelete,
              onChangeSettings: () {
                context.read<SettingsBloc>().add(
                      UpdateSettings(settings: newSettings),
                    );
              },
            ));
  }
}
