part of 'local_appointments_bloc.dart';

@immutable
sealed class LocalAppointmentsEvent {}

class FetchAppointmentsData extends LocalAppointmentsEvent {}
