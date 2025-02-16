import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_app/features/regulations/bloc/actions_regulations_bloc.dart';

class ActionsRegulationsRepository {
  ActionsRegulationsRepository({required this.firebaseFirestore});

  final FirebaseFirestore firebaseFirestore;

  Future<void> createRegulation(CreateRegulationEvent event) async {
    debugPrint('create');
    await firebaseFirestore.collection('regulations').add({
      'name': event.regulation.name,
      'duration': event.regulation.duration,
      'cost': event.regulation.cost,
    });
    debugPrint('added regulation');
  }

  Future<void> updateRegulation(UpdateRegulationEvent event) async {
    debugPrint('update');

    var id = event.regulation.id;
    firebaseFirestore.collection('regulations').doc(id).update({
      'name': event.regulation.name,
      'duration': event.regulation.duration,
      'cost': event.regulation.cost,
    }).then((_) {
      debugPrint("Document successfully updated!");
    }).catchError((error) {
      debugPrint("Error updating document: $error");
    });
  }

  Future<void> deleteRegulation(DeleteRegulationEvent event) async {
    await firebaseFirestore
        .collection('regulations')
        .doc(event.regulation.id)
        .delete();
  }
}
