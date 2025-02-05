part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Employee user;
  final bool isUpdated;

  UserLoaded({required this.user, required this.isUpdated});
}

// class UserUpdated extends UserState {
//   final Employee user;
//
//   UserUpdated({required this.user});
// }

class UserError extends UserState {
  final String error;

  UserError({required this.error});
}
