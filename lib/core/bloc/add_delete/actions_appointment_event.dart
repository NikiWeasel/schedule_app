part of 'actions_appointment_bloc.dart';

abstract class ActionsAppointmentEvent {}

class CreateAppointmentEvent extends ActionsAppointmentEvent {
  final Appointment appointment;

  CreateAppointmentEvent({required this.appointment});
}

class DeleteAppointmentEvent extends ActionsAppointmentEvent {
  final Appointment appointment;

  DeleteAppointmentEvent({required this.appointment});
}

class UpdateAppointmentEvent extends ActionsAppointmentEvent {
  final Appointment appointment;

  UpdateAppointmentEvent({required this.appointment});
}
