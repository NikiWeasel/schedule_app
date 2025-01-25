import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/core/repository/local_portfolio_photos_repository.dart';
import 'package:schedule_app/core/repository/local_regulations_repository.dart';

part 'local_regulations_event.dart';

part 'local_regulations_state.dart';

class LocalRegulationsBloc
    extends Bloc<FetchRegulationsEvent, FetchRegulationsState> {
  final LocalRegulationsRepository localRegulationsRepository;

  LocalRegulationsBloc(this.localRegulationsRepository)
      : super(LocalRegulationsInitialState()) {
    on<FetchRegulationsData>((event, emit) async {
      emit(LocalRegulationsLoadingState());
      try {
        var regs = await localRegulationsRepository.fetchRegulationsData();
        emit(LocalRegulationsLoadedState(regulations: regs));
      } catch (e) {
        emit(LocalRegulationsErrorState(errorMessage: e.toString()));
      }
    });
  }
}
