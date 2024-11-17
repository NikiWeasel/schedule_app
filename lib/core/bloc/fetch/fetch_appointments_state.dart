part of 'fetch_appointments_bloc.dart';

@immutable
sealed class FetchAppointmentsState {}

final class FetchAppointmentsInitial extends FetchAppointmentsState {}

class FetchAppointmentsLoading extends FetchAppointmentsState {}

class FetchAppointmentsLoaded extends FetchAppointmentsState {
  final List<Appointment> appointments;

  FetchAppointmentsLoaded({required this.appointments});
}

class FetchAppointmentsError extends FetchAppointmentsState {
  final String errorMessage;

  FetchAppointmentsError({required this.errorMessage});
}
