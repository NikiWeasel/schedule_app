import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/repository/local_appointments_repository.dart';

part 'local_appointments_event.dart';
part 'local_appointments_state.dart';

class LocalAppointmentsBloc
    extends Bloc<LocalAppointmentsEvent, LocalAppointmentsState> {
  final LocalAppointmentsRepository localAppointmentsRepository;
  List<Appointment> localAppos = [];
  StreamSubscription<List<Appointment>>? _appointmentsSubscription;

  LocalAppointmentsBloc(this.localAppointmentsRepository)
      : super(FetchAppointmentsInitial()) {
    on<SubscribeToAppointments>((event, emit) async {
      emit(LocalAppointmentsLoading());
      try {
        _appointmentsSubscription?.cancel();
        _appointmentsSubscription =
            localAppointmentsRepository.subscribeToAppointments().listen(
          (appointments) {
            add(UpdateAppointments(appointments: appointments));
          },
        );
      } catch (e) {
        emit(LocalAppointmentsError(errorMessage: e.toString()));
      }
    });

    on<UpdateAppointments>((event, emit) async {
      emit(LocalAppointmentsLoading());
      try {
        emit(LocalAppointmentsLoaded(appointments: event.appointments));
      } catch (e) {
        emit(LocalAppointmentsError(errorMessage: e.toString()));
      }
    });

    on<UnsubscribeFromAppointments>((event, emit) async {
      try {
        _appointmentsSubscription?.cancel();
      } catch (e) {
        emit(LocalAppointmentsError(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _appointmentsSubscription?.cancel();
    return super.close();
  }
}
