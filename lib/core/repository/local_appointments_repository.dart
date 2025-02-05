import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:schedule_app/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/regulation.dart';

class LocalAppointmentsRepository {
  LocalAppointmentsRepository(
      {required this.firebaseFirestore,
      required this.firebaseAuth,
      required this.firebaseStorage});

  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

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

  List<Appointment> addLocalAppointment(
    List<Appointment> appos,
    Appointment appointment,
  ) {
    return [...appos, appointment];
  }

  List<Appointment> deleteLocalAppointment(
      List<Appointment> appos, Appointment appointment) {
    return appos
        .where(
          (element) => element.appointmentId != appointment.appointmentId,
        )
        .toList();
  }

  List<Appointment> updateLocalAppointment(
      List<Appointment> appos, Appointment appointment) {
    var newAppos = appos
        .where(
          (element) => element.appointmentId != appointment.appointmentId,
        )
        .toList();
    return [...newAppos, appointment];
  }
}
