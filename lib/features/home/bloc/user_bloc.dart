import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/employee.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserBloc() : super(UserInitial()) {
    // on<FetchUserData>(_onFetchUserData);

    on<FetchUserData>((event, emit) async {
      emit(UserLoading());
      try {
        var employee = await _onFetchUserData(event);
        emit(UserLoaded(user: employee));
      } catch (e) {
        emit(UserError(error: e.toString()));
      }
    });

    on<UpdateUserData>((event, emit) async {
      emit(UserLoading());
      try {
        await _onUpdateUserData(event);
        // emit(UserLoadingUser());
      } catch (e) {
        emit(UserError(error: e.toString()));
      }
    });
  }

  Future<Employee> _onFetchUserData(FetchUserData event) async {
    // emit(UserLoading());
    // try {
    // Получаем текущего пользователя
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      // emit(UserError(error: 'Пользователь не авторизован'));
      throw Exception('Пользователь не авторизован');

      // return null;
    }

    // Запрашиваем данные пользователя из Firestore
    final userData =
        await _firebaseFirestore.collection('users').doc(user.uid).get();
    final data = userData.data();

    if (data == null) {
      // emit(UserError(error: 'Данные пользователя не найдены'));
      throw Exception('Данные пользователя не найдены');
      // return;
    }

    // Создаем экземпляр класса User
    final fetchedUser = Employee(
      name: data['name'],
      surname: data['surname'],
      description: data['description'],
      email: data['email'],
      number: data['number'],
      imageUrl: data['image_url'],
      employeeId: user.uid,
    );

    return fetchedUser;
    // emit(UserLoaded(user: fetchedUser));
    // } catch (e) {
    //   emit(UserError(error: e.toString()));
    // }
  }

  Future<void> _onUpdateUserData(UpdateUserData event) async {
    // emit(UserLoading());
    // try {
    // Получаем текущего пользователя
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      // emit(UserError(error: 'Пользователь не авторизован'));
      return;
    }

    var id = event.employee.employeeId;
    // _firebaseFirestore.clearPersistence();
    _firebaseFirestore.collection('users').doc(id).update({
      'name': event.employee.name,
      'surname': event.employee.surname,
      'number': event.employee.number,
      'description': event.employee.description,
      'image_url': event.employee.imageUrl,
    }).then((_) {
      debugPrint("Document successfully updated!");
    }).catchError((error) {
      debugPrint("Error updating document: $error");
    });

    // emit(UserLoaded(user: fetchedUser));
    // } catch (e) {
    //   emit(UserError(error: e.toString()));
    // }
  }
}
