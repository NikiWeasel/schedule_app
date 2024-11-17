part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class FetchUserData extends UserEvent {}

class UpdateUserData extends UserEvent {
  final Employee employee;

  UpdateUserData({required this.employee});
}
