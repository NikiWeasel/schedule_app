part of 'local_employees_bloc.dart';

@immutable
sealed class LocalEmployeesState {}

final class LocalEmployeesInitial extends LocalEmployeesState {}

class LocalEmployeesLoading extends LocalEmployeesState {}

class LocalEmployeesLoaded extends LocalEmployeesState {
  final List<Employee> employees;

  LocalEmployeesLoaded({required this.employees});
}

class LocalEmployeesError extends LocalEmployeesState {
  final String errorMessage;

  LocalEmployeesError({required this.errorMessage});
}
