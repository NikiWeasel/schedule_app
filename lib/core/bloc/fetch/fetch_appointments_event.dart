part of 'fetch_appointments_bloc.dart';

@immutable
sealed class FetchAppointmentsEvent {}

class FetchAppointmentsData extends FetchAppointmentsEvent {}
