import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/regulation.dart';

part 'fetch_regulations_event.dart';

part 'fetch_regulations_state.dart';

class FetchRegulationsBloc
    extends Bloc<FetchRegulationsEvent, FetchRegulationsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FetchRegulationsBloc() : super(FetchRegulationsInitialState()) {
    on<FetchRegulationsData>(_onFetchRegulationsData);
  }

  Future<void> _onFetchRegulationsData(
      FetchRegulationsData event, Emitter<FetchRegulationsState> emit) async {
    print('bloc triggered');

    emit(FetchRegulationsLoadingState());

    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('regulations').get();

      final List<Regulation> allAppointments = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Regulation(
            name: data['name'],
            duration: data['duration'],
            cost: data['cost'],
            id: doc.id);
      }).toList();

      // if (allAppointments.isEmpty) {
      //   emit(FetchRegulationsErrorState(
      //       errorMessage: 'Данные регламентов не найдены'));
      //   return;
      // }
      List<Regulation> newList = List.from(allAppointments);

      emit(FetchRegulationsLoadedState(regulations: newList));
    } catch (e) {
      emit(FetchRegulationsErrorState(errorMessage: e.toString()));
    }
  }
}
