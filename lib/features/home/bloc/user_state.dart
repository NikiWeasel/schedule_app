part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Employee user;

  UserLoaded({required this.user});
}

class UserUpdated extends UserState {}

class UserError extends UserState {
  final String error;

  UserError({required this.error});
}
