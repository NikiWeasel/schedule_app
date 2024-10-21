import 'package:bloc/bloc.dart';
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
      : super(ActionsAppointmentInitialState());

  Stream<ActionsAppointmentState> mapEventToState(
      ActionsAppointmentEvent event) async* {
    if (event is CreateAppointmentEvent) {
      yield ActionsAppointmentLoadingState();
      try {
        await _createAppointment(event);
        yield ActionsAppointmentLoadedState();
      } catch (e) {
        yield ActionsAppointmentErrorState(error: e.toString());
      }
    }
    if (event is DeleteAppointmentEvent) {
      yield ActionsAppointmentLoadingState();
      try {
        await _deleteAppointment(event);
        yield ActionsAppointmentLoadedState();
      } catch (e) {
        yield ActionsAppointmentErrorState(error: e.toString());
      }
    }
  }

  Future<void> _createAppointment(CreateAppointmentEvent event) async {
    await _firebaseFirestore.collection('appointments').add({
      'masterId': event.appointment.masterId,
      'client': event.appointment.client,
      'serviceName': event.appointment.serviceName,
      'startTime': event.appointment.startTime,
      'duration': event.appointment.duration,
      'date': event.appointment.date.toString(),
    });
  }

  Future<void> _deleteAppointment(DeleteAppointmentEvent event) async {
    await _firebaseFirestore
        .collection('appointments')
        .doc(event.appointment.appointmentId)
        .delete();
  }
}
