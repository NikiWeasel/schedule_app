import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/regulation.dart';

class LocalRegulationsRepository {
  LocalRegulationsRepository({
    required this.firebaseFirestore,
  });

  final FirebaseFirestore firebaseFirestore;

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
}
