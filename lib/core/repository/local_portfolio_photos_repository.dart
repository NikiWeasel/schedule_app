import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/regulation.dart';

class LocalPortfolioPhotosRepository {
  LocalPortfolioPhotosRepository(
      {required this.firebaseAuth, required this.firebaseStorage});

  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

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
}
