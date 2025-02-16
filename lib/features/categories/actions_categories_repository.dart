import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_app/features/categories/bloc/actions_categories_bloc.dart';

class ActionsCategoriesRepository {
  ActionsCategoriesRepository({required this.firebaseFirestore});

  final FirebaseFirestore firebaseFirestore;

  Future<void> createCategory(CreateCategoryEvent event) async {
    debugPrint('create');
    await firebaseFirestore.collection('categories').add({
      'id': event.category.name,
      'name': event.category.name,
      'description': event.category.description,
      'regulationIds': event.category.regulationIds,
    });
    debugPrint('added category');
  }

  Future<void> updateCategory(UpdateCategoryEvent event) async {
    debugPrint('update');

    var id = event.category.id;
    firebaseFirestore.collection('categories').doc(id).update({
      'name': event.category.name,
      'description': event.category.description,
      'regulationIds': event.category.regulationIds,
    }).then((_) {
      debugPrint("Document successfully updated!");
    }).catchError((error) {
      debugPrint("Error updating document: $error");
    });
  }

  Future<void> deleteCategory(DeleteCategoryEvent event) async {
    await firebaseFirestore
        .collection('categories')
        .doc(event.category.id)
        .delete();
  }
}
