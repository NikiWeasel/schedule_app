import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schedule_app/core/models/appointment.dart';

class LocalAppointmentsRepository {
  LocalAppointmentsRepository({
    required this.firebaseFirestore,
  });

  final FirebaseFirestore firebaseFirestore;

  Stream<List<Appointment>> subscribeToAppointments() {
    return firebaseFirestore.collection('appointments').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Appointment(
            masterId: data['masterId'],
            clientName: data['clientName'],
            clientNumber: data['clientNumber'],
            serviceName: data['serviceName'],
            duration: data['duration'],
            date: data['date'].toDate(),
            appointmentId: doc.id,
          );
        }).toList();
      },
    );
  }
}
