import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'package:schedule_app/core/models/regulation.dart';

part 'actions_regulations_event.dart';

part 'actions_regulations_state.dart';

class ActionsRegulationsBloc
    extends Bloc<ActionsRegulationsEvent, ActionsRegulationsState> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ActionsRegulationsBloc() : super(ActionsRegulationsInitialState()) {
    on<CreateRegulationEvent>((event, emit) async {
      emit(ActionsRegulationsLoadingState());
      try {
        await _createAppointment(event);
        emit(ActionsRegulationsLoadedState());
      } catch (e) {
        emit(ActionsRegulationsErrorState(error: e.toString()));
      }
    });

    on<DeleteRegulationEvent>((event, emit) async {
      emit(ActionsRegulationsLoadingState());
      try {
        await _deleteAppointment(event);
        emit(ActionsRegulationsDeletedState());
      } catch (e) {
        emit(ActionsRegulationsErrorState(error: e.toString()));
      }
    });

    on<UpdateRegulationEvent>((event, emit) async {
      emit(ActionsRegulationsLoadingState());
      try {
        await _updateAppointment(event);
        emit(ActionsRegulationsUpdatedState());
      } catch (e) {
        emit(ActionsRegulationsErrorState(error: e.toString()));
      }
    });
  }

  Future<void> _createAppointment(CreateRegulationEvent event) async {
    debugPrint('create');
    await _firebaseFirestore.collection('regulations').add({
      'name': event.regulation.name,
      'duration': event.regulation.duration,
      'cost': event.regulation.cost,
    });
    debugPrint('added regulation');
  }

  Future<void> _updateAppointment(UpdateRegulationEvent event) async {
    debugPrint('update');

    var id = event.regulation.id;
    _firebaseFirestore.collection('regulations').doc(id).update({
      'name': event.regulation.name,
      'duration': event.regulation.duration,
      'cost': event.regulation.cost,
    }).then((_) {
      debugPrint("Document successfully updated!");
    }).catchError((error) {
      debugPrint("Error updating document: $error");
    });
  }

  Future<void> _deleteAppointment(DeleteRegulationEvent event) async {
    await _firebaseFirestore
        .collection('regulations')
        .doc(event.regulation.id)
        .delete();
  }
}
