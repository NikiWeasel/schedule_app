import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/core/repository/fetch_data_repository.dart';

part 'fetch_regulations_event.dart';

part 'fetch_regulations_state.dart';

class FetchRegulationsBloc
    extends Bloc<FetchRegulationsEvent, FetchRegulationsState> {
  final FetchDataRepository fetchDataRepository;

  FetchRegulationsBloc(this.fetchDataRepository)
      : super(FetchRegulationsInitialState()) {
    on<FetchRegulationsData>((event, emit) async {
      emit(FetchRegulationsLoadingState());
      try {
        var regs = await fetchDataRepository.fetchRegulationsData();
        emit(FetchRegulationsLoadedState(regulations: regs));
      } catch (e) {
        emit(FetchRegulationsErrorState(errorMessage: e.toString()));
      }
    });
  }
}
