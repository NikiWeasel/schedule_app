part of 'actions_appointment_bloc.dart';

abstract class ActionsAppointmentState {}

class ActionsAppointmentInitialState extends ActionsAppointmentState {}

class ActionsAppointmentLoadingState extends ActionsAppointmentState {}

class ActionsAppointmentLoadedState extends ActionsAppointmentState {}

class ActionsAppointmentErrorState extends ActionsAppointmentState {
  final String error;

  ActionsAppointmentErrorState({required this.error});
}
