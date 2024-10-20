part of 'appointments_bloc.dart';

@immutable
sealed class AppointmentsEvent {}

class FetchAppointmentsData extends AppointmentsEvent {}
