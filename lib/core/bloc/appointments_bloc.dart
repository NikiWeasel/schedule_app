import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/appointment.dart';

part 'appointments_event.dart';

part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppointmentsBloc() : super(AppointmentsInitial()) {
    on<AppointmentsEvent>((event, emit) {
      on<FetchAppointmentsData>(_onFetchAppointmentsData);
    });
  }

  Future<void> _onFetchAppointmentsData(
      FetchAppointmentsData event, Emitter<AppointmentsState> emit) async {
    emit(AppointmentsLoading());
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('appointments').get();

      final List<Appointment> allEmployees = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Appointment(
            master: data['master'],
            client: data['client'],
            startTime: data['startTime'],
            duration: data['duration']);
      }).toList();

      if (allEmployees.isEmpty) {
        emit(
            AppointmentsError(errorMessage: 'Данные пользователей не найдены'));
        return;
      }

      emit(AppointmentsLoaded(appointments: allEmployees));
    } catch (e) {
      emit(AppointmentsError(errorMessage: e.toString()));
    }
  }
}
