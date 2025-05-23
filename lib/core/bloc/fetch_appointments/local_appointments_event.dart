part of 'local_appointments_bloc.dart';

@immutable
sealed class LocalAppointmentsEvent {}

class SubscribeToAppointments extends LocalAppointmentsEvent {}

class UnsubscribeFromAppointments extends LocalAppointmentsEvent {}

class UpdateAppointments extends LocalAppointmentsEvent {
  final List<Appointment> appointments;

  UpdateAppointments({required this.appointments});
}
