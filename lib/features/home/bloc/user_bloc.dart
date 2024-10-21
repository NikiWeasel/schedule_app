import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/employee.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserBloc() : super(UserInitial()) {
    on<FetchUserData>(_onFetchUserData);
  }

  Future<void> _onFetchUserData(
      FetchUserData event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      // Получаем текущего пользователя
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        emit(UserError(errorMessage: 'Пользователь не авторизован'));
        return;
      }

      // Запрашиваем данные пользователя из Firestore
      final userData = await _firestore.collection('users').doc(user.uid).get();
      final data = userData.data();

      if (data == null) {
        emit(UserError(errorMessage: 'Данные пользователя не найдены'));
        return;
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

      emit(UserLoaded(user: fetchedUser));
    } catch (e) {
      emit(UserError(errorMessage: e.toString()));
    }
  }
}
