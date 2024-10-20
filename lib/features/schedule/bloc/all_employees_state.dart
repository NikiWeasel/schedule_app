part of 'all_employees_bloc.dart';

@immutable
sealed class AllEmployeesState {}

final class AllEmployeesInitial extends AllEmployeesState {}

class AllEmployeesLoading extends AllEmployeesState {}

class AllEmployeesLoaded extends AllEmployeesState {
  final List<Employee> employees;

  AllEmployeesLoaded({required this.employees});
}

class AllEmployeesError extends AllEmployeesState {
  final String errorMessage;

  AllEmployeesError({required this.errorMessage});
}
