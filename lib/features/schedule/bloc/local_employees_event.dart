part of 'local_employees_bloc.dart';

@immutable
sealed class LocalEmployeesEvent {}

class FetchAllEmployeesData extends LocalEmployeesEvent {}
