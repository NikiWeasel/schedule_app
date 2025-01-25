import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';

class UserRepository {
  UserRepository({required this.firebaseFirestore, required this.firebaseAuth});

  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  Future<Employee> fetchUserData(FetchUserData event) async {
    int maxRetries = 10;
    const Duration delayBetweenRetries = Duration(seconds: 1);

    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Пользователь не авторизован');
    }

    Map<String, dynamic>? data;

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      final userData =
          await firebaseFirestore.collection('users').doc(user.uid).get();
      data = userData.data();

      if (userData.exists) {
        break;
      }

      // Ждем перед следующей попыткой
      await Future.delayed(delayBetweenRetries);
    }

    if (data == null) {
      throw Exception(
          'Данные пользователя не найдены\nПопробуйте перезайти позже');
    }

    // Создаем экземпляр класса User
    final fetchedUser = Employee(
      name: data['name'],
      surname: data['surname'],
      isAdmin: data['is_admin'],
      description: data['description'],
      email: data['email'],
      number: data['number'],
      imageUrl: data['image_url'],
      employeeId: user.uid,
    );

    return fetchedUser;
  }

  Future<void> updateUserData(UpdateUserData event) async {
    // emit(UserLoading());
    // try {
    // Получаем текущего пользователя
    final user = firebaseAuth.currentUser;
    if (user == null) {
      // emit(UserError(error: 'Пользователь не авторизован'));
      return;
    }

    var id = event.employee.employeeId;
    // _firebaseFirestore.clearPersistence();
    firebaseFirestore.collection('users').doc(id).update({
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
