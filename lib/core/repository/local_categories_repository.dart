import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/category.dart';
import 'package:schedule_app/core/models/category.dart';

class LocalCategoriesRepository {
  LocalCategoriesRepository({
    required this.firebaseFirestore,
  });

  final FirebaseFirestore firebaseFirestore;

  Future<List<RegCategory>> fetchCategoriesData() async {
    final QuerySnapshot snapshot =
        await firebaseFirestore.collection('categories').get();

    final List<RegCategory> allCats = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return RegCategory(
          description: data['description'],
          name: data['name'],
          regulationIds: (data['regulationIds'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
          id: doc.id);
    }).toList();
    return allCats;
  }

  List<RegCategory> addLocalCategory(
    List<RegCategory> cats,
    RegCategory category,
  ) {
    return [...cats, category];
  }

  List<RegCategory> deleteLocalCategory(
    List<RegCategory> cats,
    RegCategory category,
  ) {
    return cats
        .where(
          (element) => element.id != category.id,
        )
        .toList();
  }

  List<RegCategory> updateLocalCategory(
    List<RegCategory> cats,
    RegCategory category,
  ) {
    var newRegs = cats
        .where(
          (element) => element.id != category.id,
        )
        .toList();
    return [...newRegs, category];
  }
}
