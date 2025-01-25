import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';

class ActionsAppointmentRepository {
  ActionsAppointmentRepository({required this.firebaseFirestore});

  final FirebaseFirestore firebaseFirestore;

  Future<void> createAppointment(CreateAppointmentEvent event) async {
    debugPrint('create');
    await firebaseFirestore.collection('appointments').add({
      'masterId': event.appointment.masterId,
      'clientName': event.appointment.clientName,
      'clientNumber': event.appointment.clientNumber,
      'serviceName': event.appointment.serviceName,
      'duration': event.appointment.duration,
      'date': Timestamp.fromDate(event.appointment.date),
    });
    debugPrint('added appoint');
  }

  Future<void> updateAppointment(UpdateAppointmentEvent event) async {
    debugPrint('update');

    var id = event.appointment.appointmentId;
    firebaseFirestore.collection('appointments').doc(id).update({
      'masterId': event.appointment.masterId,
      'clientName': event.appointment.clientName,
      'clientNumber': event.appointment.clientNumber,
      'serviceName': event.appointment.serviceName,
      'duration': event.appointment.duration,
      'date': Timestamp.fromDate(event.appointment.date),
    }).then((_) {
      debugPrint("Document successfully updated!");
    }).catchError((error) {
      debugPrint("Error updating document: $error");
    });
  }

  Future<void> deleteAppointment(DeleteAppointmentEvent event) async {
    await firebaseFirestore
        .collection('appointments')
        .doc(event.appointment.appointmentId)
        .delete();
  }

  Future<void> deleteAllAppointments(DeleteAllAppointmentsEvent event) async {
    var allAppos = event.appointments;
    for (var a in allAppos) {
      await firebaseFirestore
          .collection('appointments')
          .doc(a.appointmentId)
          .delete();
    }
  }
}
