part of 'local_appointments_bloc.dart';

@immutable
sealed class LocalAppointmentsEvent {}

class FetchAppointmentsData extends LocalAppointmentsEvent {}

class AddLocalAppointment extends LocalAppointmentsEvent {
  final Appointment appointment;

  AddLocalAppointment({required this.appointment});
}

class UpdateLocalAppointment extends LocalAppointmentsEvent {
  final Appointment appointment;

  UpdateLocalAppointment({required this.appointment});
}

class DeleteLocalAppointment extends LocalAppointmentsEvent {
  final Appointment appointment;

  // final List<Appointment> appos;

  DeleteLocalAppointment({required this.appointment});
}
