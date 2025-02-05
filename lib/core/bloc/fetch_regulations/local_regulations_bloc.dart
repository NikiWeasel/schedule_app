import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/core/repository/local_portfolio_photos_repository.dart';
import 'package:schedule_app/core/repository/local_regulations_repository.dart';

part 'local_regulations_event.dart';

part 'local_regulations_state.dart';

class LocalRegulationsBloc
    extends Bloc<LocalRegulationsEvent, FetchRegulationsState> {
  final LocalRegulationsRepository localRegulationsRepository;
  List<Regulation> localRegs = [];

  LocalRegulationsBloc(this.localRegulationsRepository)
      : super(LocalRegulationsInitialState()) {
    on<FetchRegulationsData>((event, emit) async {
      emit(LocalRegulationsLoadingState());
      try {
        localRegs = await localRegulationsRepository.fetchRegulationsData();
        emit(LocalRegulationsLoadedState(regulations: localRegs));
      } catch (e) {
        emit(LocalRegulationsErrorState(errorMessage: e.toString()));
      }
    });

    on<AddLocalRegulation>((event, emit) async {
      emit(LocalRegulationsLoadingState());
      try {
        localRegs = localRegulationsRepository.addLocalRegulation(
            localRegs, event.regulation);

        emit(LocalRegulationsLoadedState(regulations: localRegs));
      } catch (e) {
        emit(LocalRegulationsErrorState(errorMessage: e.toString()));
      }
    });

    on<UpdateLocalRegulation>((event, emit) async {
      emit(LocalRegulationsLoadingState());
      try {
        localRegs = localRegulationsRepository.updateLocalRegulation(
            localRegs, event.regulation);

        emit(LocalRegulationsLoadedState(regulations: localRegs));
      } catch (e) {
        emit(LocalRegulationsErrorState(errorMessage: e.toString()));
      }
    });

    on<DeleteLocalRegulation>((event, emit) async {
      emit(LocalRegulationsLoadingState());
      try {
        localRegs = localRegulationsRepository.deleteLocalRegulation(
            localRegs, event.regulation);

        emit(LocalRegulationsLoadedState(regulations: localRegs));
      } catch (e) {
        emit(LocalRegulationsErrorState(errorMessage: e.toString()));
      }
    });
  }
}
