part of 'all_employees_bloc.dart';

@immutable
sealed class AllEmployeesEvent {}

class FetchAllEmployeesData extends AllEmployeesEvent {}
