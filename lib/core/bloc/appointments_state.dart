part of 'appointments_bloc.dart';

@immutable
sealed class AppointmentsState {}

final class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<Appointment> appointments;

  AppointmentsLoaded({required this.appointments});
}

class AppointmentsError extends AppointmentsState {
  final String errorMessage;

  AppointmentsError({required this.errorMessage});
}
