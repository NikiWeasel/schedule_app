import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/appointment.dart';

part 'actions_appointment_event.dart';

part 'actions_appointment_state.dart';

class ActionsAppointmentBloc
    extends Bloc<ActionsAppointmentEvent, ActionsAppointmentState> {
  final FirebaseFirestore _firebaseFirestore;

  ActionsAppointmentBloc(this._firebaseFirestore)
      : super(ActionsAppointmentInitialState()) {
    // Register the handler for CreateAppointmentEvent
    on<CreateAppointmentEvent>((event, emit) async {
      emit(ActionsAppointmentLoadingState());
      try {
        await _createAppointment(event);
        emit(ActionsAppointmentLoadedState());
      } catch (e) {
        emit(ActionsAppointmentErrorState(error: e.toString()));
      }
    });

    // Register the handler for DeleteAppointmentEvent
    on<DeleteAppointmentEvent>((event, emit) async {
      emit(ActionsAppointmentLoadingState());
      try {
        await _deleteAppointment(event);
        emit(ActionsAppointmentLoadedState());
      } catch (e) {
        emit(ActionsAppointmentErrorState(error: e.toString()));
      }
    });
  }

  Future<void> _createAppointment(CreateAppointmentEvent event) async {
    // debugPrint(event.appointment.toString());
    await _firebaseFirestore.collection('appointments').add({
      'masterId': event.appointment.masterId,
      'clientName': event.appointment.clientName,
      'clientNumber': event.appointment.clientNumber,
      'serviceName': event.appointment.serviceName,
      'startTime': event.appointment.startTime,
      'duration': event.appointment.duration,
      'date': Timestamp.fromDate(event.appointment.date),
    });
    debugPrint('added appoint');
  }

  Future<void> _deleteAppointment(DeleteAppointmentEvent event) async {
    await _firebaseFirestore
        .collection('appointments')
        .doc(event.appointment.appointmentId)
        .delete();
  }
}
