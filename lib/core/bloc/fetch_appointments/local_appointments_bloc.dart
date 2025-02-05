import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/app.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/repository/local_appointments_repository.dart';
import 'package:schedule_app/core/repository/local_portfolio_photos_repository.dart';

part 'local_appointments_event.dart';

part 'local_appointments_state.dart';

class LocalAppointmentsBloc
    extends Bloc<LocalAppointmentsEvent, LocalAppointmentsState> {
  final LocalAppointmentsRepository localAppointmentsRepository;
  List<Appointment> localAppos = [];

  LocalAppointmentsBloc(this.localAppointmentsRepository)
      : super(FetchAppointmentsInitial()) {
    on<FetchAppointmentsData>((event, emit) async {
      emit(LocalAppointmentsLoading());
      try {
        localAppos = await localAppointmentsRepository.fetchAppointmentsData();
        emit(LocalAppointmentsLoaded(appointments: localAppos));
      } catch (e) {
        emit(LocalAppointmentsError(errorMessage: e.toString()));
      }
    });

    on<AddLocalAppointment>((event, emit) async {
      emit(LocalAppointmentsLoading());
      try {
        localAppos = localAppointmentsRepository.addLocalAppointment(
            localAppos, event.appointment);

        emit(LocalAppointmentsLoaded(appointments: localAppos));
      } catch (e) {
        emit(LocalAppointmentsError(errorMessage: e.toString()));
      }
    });

    on<UpdateLocalAppointment>((event, emit) async {
      emit(LocalAppointmentsLoading());
      try {
        localAppos = localAppointmentsRepository.updateLocalAppointment(
            localAppos, event.appointment);

        emit(LocalAppointmentsLoaded(appointments: localAppos));
      } catch (e) {
        emit(LocalAppointmentsError(errorMessage: e.toString()));
      }
    });

    on<DeleteLocalAppointment>((event, emit) async {
      emit(LocalAppointmentsLoading());
      try {
        localAppos = localAppointmentsRepository.deleteLocalAppointment(
            localAppos, event.appointment);

        emit(LocalAppointmentsLoaded(appointments: localAppos));
      } catch (e) {
        emit(LocalAppointmentsError(errorMessage: e.toString()));
      }
    });
  }
}
