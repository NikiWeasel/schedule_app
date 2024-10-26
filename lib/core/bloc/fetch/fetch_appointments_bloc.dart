import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
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

  Future<void> _onFetchAppointmentsData(
      FetchAppointmentsData event, Emitter<FetchAppointmentsState> emit) async {
    emit(FetchAppointmentsLoading());
    DateFormat format = DateFormat("dd.MM.yyyy");

    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('appointments').get();

      final List<Appointment> allEmployees = snapshot.docs.map((doc) {
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

      if (allEmployees.isEmpty) {
        emit(FetchAppointmentsError(
            errorMessage: 'Данные пользователей не найдены'));
        return;
      }

      emit(FetchAppointmentsLoaded(appointments: allEmployees));
    } catch (e) {
      emit(FetchAppointmentsError(errorMessage: e.toString()));
    }
  }
}
