part of 'local_appointments_bloc.dart';

@immutable
sealed class LocalAppointmentsState {}

final class FetchAppointmentsInitial extends LocalAppointmentsState {}

class LocalAppointmentsLoading extends LocalAppointmentsState {}

class LocalAppointmentsLoaded extends LocalAppointmentsState {
  final List<Appointment> appointments;

  LocalAppointmentsLoaded({required this.appointments});
}

class LocalAppointmentsError extends LocalAppointmentsState {
  final String errorMessage;

  LocalAppointmentsError({required this.errorMessage});
}
