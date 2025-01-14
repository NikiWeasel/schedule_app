import 'package:cloud_firestore/cloud_firestore.dart';

class Settings {
  Settings(
      {required this.monthsOldToDelete,
      required this.deleteWithoutAsking,
      required this.themeSeed});

  final int monthsOldToDelete;
  final bool deleteWithoutAsking;
  final int themeSeed;
}
