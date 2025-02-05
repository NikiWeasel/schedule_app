part of 'actions_appointment_bloc.dart';

abstract class ActionsAppointmentState {}

class ActionsAppointmentInitialState extends ActionsAppointmentState {}

class ActionsAppointmentLoadingState extends ActionsAppointmentState {}

class ActionsAppointmentLoadedState extends ActionsAppointmentState {
  final Appointment appo;

  ActionsAppointmentLoadedState({required this.appo});
}

class ActionsAppointmentUpdatedState extends ActionsAppointmentState {
  final Appointment appo;

  ActionsAppointmentUpdatedState({required this.appo});
}

class ActionsAppointmentDeletedState extends ActionsAppointmentState {
  final List<Appointment> appos;

  ActionsAppointmentDeletedState({required this.appos});
}

class ActionsAppointmentErrorState extends ActionsAppointmentState {
  final String error;

  ActionsAppointmentErrorState({required this.error});
}
