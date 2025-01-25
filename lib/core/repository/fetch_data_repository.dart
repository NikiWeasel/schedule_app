import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/regulation.dart';

class FetchDataRepository {
  FetchDataRepository(
      {required this.firebaseFirestore,
      required this.firebaseAuth,
      required this.firebaseStorage});

  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  Future<List<String>> fetchPortfolioPhotos() async {
    final employeeId = firebaseAuth.currentUser?.uid;
    if (employeeId == null) {
      throw Exception('User: null');
    }

    final storageRef = firebaseStorage
        .ref()
        .child('employee_portfolio_images')
        .child(employeeId);
    final listResult = await storageRef.listAll();

    return await Future.wait(
      listResult.items.map((item) async => await item.getDownloadURL()),
    );
  }

  Future<List<Appointment>> fetchAppointmentsData() async {
    final QuerySnapshot snapshot =
        await firebaseFirestore.collection('appointments').get();

    final List<Appointment> allAppointments = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Appointment(
          masterId: data['masterId'],
          clientName: data['clientName'],
          clientNumber: data['clientNumber'],
          serviceName: data['serviceName'],
          duration: data['duration'],
          date: data['date'].toDate(),
          appointmentId: doc.id);
    }).toList();
    return allAppointments;
  }

  Future<List<Regulation>> fetchRegulationsData() async {
    final QuerySnapshot snapshot =
        await firebaseFirestore.collection('regulations').get();

    final List<Regulation> allRegs = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Regulation(
          name: data['name'],
          duration: data['duration'],
          cost: data['cost'],
          id: doc.id);
    }).toList();
    return allRegs;
  }

  // Future<Employee> fetchUserData() async {
  //   int maxRetries = 10;
  //   const Duration delayBetweenRetries = Duration(seconds: 1);
  //
  //   final user = firebaseAuth.currentUser;
  //   if (user == null) {
  //     throw Exception('Пользователь не авторизован');
  //   }
  //
  //   Map<String, dynamic>? data;
  //
  //   for (int attempt = 0; attempt < maxRetries; attempt++) {
  //     final userData =
  //     await firebaseFirestore.collection('users').doc(user.uid).get();
  //     data = userData.data();
  //
  //     if (userData.exists) {
  //       break;
  //     }
  //     // Ждем перед следующей попыткой
  //     await Future.delayed(delayBetweenRetries);
  //   }
  //
  //   if (data == null) {
  //     throw Exception(
  //         'Данные пользователя не найдены\nПопробуйте перезайти позже');
  //   }
  //
  //   // Создаем экземпляр класса User
  //   final fetchedUser = Employee(
  //     name: data['name'],
  //     surname: data['surname'],
  //     isAdmin: data['is_admin'],
  //     description: data['description'],
  //     email: data['email'],
  //     number: data['number'],
  //     imageUrl: data['image_url'],
  //     employeeId: user.uid,
  //   );
  //
  //   return fetchedUser;
  // }

  Future<List<Employee>> fetchAllEmployeesData() async {
    final QuerySnapshot snapshot =
        await firebaseFirestore.collection('users').get();

    final List<Employee> allEmployees = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Employee(
        name: data['name'],
        surname: data['surname'],
        isAdmin: data['is_admin'],
        description: data['description'],
        email: data['email'],
        number: data['number'],
        imageUrl: data['image_url'],
        employeeId: doc.id,
      );
    }).toList();

    if (allEmployees.isEmpty) {
      throw Exception('Данные пользователей не найдены');
    }
    return allEmployees;
  }
}
