import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/app.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/appointment.dart';

part 'fetch_appointments_event.dart';

part 'fetch_appointments_state.dart';

class FetchAppointmentsBloc
    extends Bloc<FetchAppointmentsEvent, FetchAppointmentsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FetchAppointmentsBloc() : super(FetchAppointmentsInitial()) {
    on<FetchAppointmentsData>(_onFetchAppointmentsData);
  }

  Future<void> _onFetchAppointmentsData(FetchAppointmentsData event,
      Emitter<FetchAppointmentsState> emit) async {
    print('bloc triggered');

    emit(FetchAppointmentsLoading());
    DateFormat format = DateFormat("dd.MM.yyyy");

    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('appointments').get();

      final List<Appointment> allAppointments = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Appointment(
            masterId: data['masterId'],
            clientName: data['clientName'],
            clientNumber: data['clientNumber'],
            serviceName: data['serviceName'],
            startTime: data['startTime'],
            duration: data['duration'],
            date: data['date'].toDate(),
            appointmentId: doc.id);
      }).toList();

      if (allAppointments.isEmpty) { //TODO: Добавить обработчик
        // emit(FetchAppointmentsError(
        //     errorMessage: 'Данные пользователей не найдены'));
        // return;
      }
      List<Appointment> newList = List.from(allAppointments);

      emit(FetchAppointmentsLoaded(appointments: newList));
    } catch (e) {
      emit(FetchAppointmentsError(errorMessage: e.toString()));
    }
  }
}
