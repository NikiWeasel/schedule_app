import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/app.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/repository/fetch_data_repository.dart';

part 'fetch_appointments_event.dart';

part 'fetch_appointments_state.dart';

class FetchAppointmentsBloc
    extends Bloc<FetchAppointmentsEvent, FetchAppointmentsState> {
  final FetchDataRepository fetchDataRepository;

  FetchAppointmentsBloc(this.fetchDataRepository)
      : super(FetchAppointmentsInitial()) {
    on<FetchAppointmentsData>((event, emit) async {
      emit(FetchAppointmentsLoading());
      try {
        var appos = await fetchDataRepository.fetchAppointmentsData();
        emit(FetchAppointmentsLoaded(appointments: appos));
      } catch (e) {
        emit(FetchAppointmentsError(errorMessage: e.toString()));
      }
    });
  }
}
