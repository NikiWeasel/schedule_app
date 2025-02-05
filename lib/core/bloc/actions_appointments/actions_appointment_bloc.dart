import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/repository/actions_appointment_repository.dart';

part 'actions_appointment_event.dart';

part 'actions_appointment_state.dart';

class ActionsAppointmentBloc
    extends Bloc<ActionsAppointmentEvent, ActionsAppointmentState> {
  final ActionsAppointmentRepository actionsAppointmentRepository;

  ActionsAppointmentBloc(this.actionsAppointmentRepository)
      : super(ActionsAppointmentInitialState()) {
    // Register the handler for CreateAppointmentEvent
    on<CreateAppointmentEvent>((event, emit) async {
      emit(ActionsAppointmentLoadingState());
      try {
        await actionsAppointmentRepository.createAppointment(event);
        emit(ActionsAppointmentLoadedState(appo: event.appointment));
      } catch (e) {
        emit(ActionsAppointmentErrorState(error: e.toString()));
      }
    });

    // Register the handler for DeleteAppointmentEvent
    on<DeleteAppointmentEvent>((event, emit) async {
      emit(ActionsAppointmentLoadingState());
      try {
        await actionsAppointmentRepository.deleteAppointment(event);
        emit(ActionsAppointmentDeletedState(appos: [event.appointment]));
      } catch (e) {
        emit(ActionsAppointmentErrorState(error: e.toString()));
      }
    });

    on<DeleteAllAppointmentsEvent>((event, emit) async {
      emit(ActionsAppointmentLoadingState());
      try {
        await actionsAppointmentRepository.deleteAllAppointments(event);
        emit(ActionsAppointmentDeletedState(appos: event.appointments));
      } catch (e) {
        emit(ActionsAppointmentErrorState(error: e.toString()));
      }
    });

    on<UpdateAppointmentEvent>((event, emit) async {
      emit(ActionsAppointmentLoadingState());
      try {
        await actionsAppointmentRepository.updateAppointment(event);
        emit(ActionsAppointmentUpdatedState(appo: event.appointment));
      } catch (e) {
        emit(ActionsAppointmentErrorState(error: e.toString()));
      }
    });
  }
}
