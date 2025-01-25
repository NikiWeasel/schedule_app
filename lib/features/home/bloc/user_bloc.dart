import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/features/home/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUserData>((event, emit) async {
      emit(UserLoading());
      try {
        var employee = await userRepository.fetchUserData(event);
        emit(UserLoaded(user: employee));
      } catch (e) {
        emit(UserError(error: e.toString()));
      }
    });

    on<UpdateUserData>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.updateUserData(event);
        emit(UserUpdated());
      } catch (e) {
        emit(UserError(error: e.toString()));
      }
    });
  }
}
