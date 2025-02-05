import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/features/regulations/actions_regulations_repository.dart';

part 'actions_regulations_event.dart';

part 'actions_regulations_state.dart';

class ActionsRegulationsBloc
    extends Bloc<ActionsRegulationsEvent, ActionsRegulationsState> {
  final ActionsRegulationsRepository actionsRegulationsRepository;

  ActionsRegulationsBloc(this.actionsRegulationsRepository)
      : super(ActionsRegulationsInitialState()) {
    on<CreateRegulationEvent>((event, emit) async {
      emit(ActionsRegulationsLoadingState());
      try {
        await actionsRegulationsRepository.createAppointment(event);
        emit(ActionsRegulationsLoadedState(reg: event.regulation));
      } catch (e) {
        emit(ActionsRegulationsErrorState(error: e.toString()));
      }
    });

    on<DeleteRegulationEvent>((event, emit) async {
      emit(ActionsRegulationsLoadingState());
      try {
        await actionsRegulationsRepository.deleteAppointment(event);
        emit(ActionsRegulationsDeletedState(reg: event.regulation));
      } catch (e) {
        emit(ActionsRegulationsErrorState(error: e.toString()));
      }
    });

    on<UpdateRegulationEvent>((event, emit) async {
      emit(ActionsRegulationsLoadingState());
      try {
        await actionsRegulationsRepository.updateAppointment(event);
        emit(ActionsRegulationsUpdatedState(reg: event.regulation));
      } catch (e) {
        emit(ActionsRegulationsErrorState(error: e.toString()));
      }
    });
  }
}
