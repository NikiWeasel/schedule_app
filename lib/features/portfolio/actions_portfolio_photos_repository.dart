import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_app/features/portfolio/bloc/actions_portfolio_photos_bloc.dart';
import 'package:uuid/uuid.dart';

class ActionsPortfolioPhotosRepository {
  ActionsPortfolioPhotosRepository(
      {required this.firebaseAuth, required this.firebaseStorage});

  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final employeeId = FirebaseAuth.instance.currentUser?.uid;

  Future<String> createPhoto(CreatePortfolioPhotoEvent event) async {
    debugPrint('create');
    if (employeeId == null) {
      throw Exception('User: null');
    }
    var uuid = const Uuid();
    final name = uuid.v6();

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('employee_portfolio_images')
        // .child(employeeId!)
        .child('$employeeId $name.jpg');

    await storageRef.putFile(event.imageFile);

    debugPrint('added photo');
    return storageRef.getDownloadURL();
  }

  Future<void> deletePhoto(DeletePortfolioPhotoEvent event) async {
    if (employeeId == null) {
      throw Exception('User: null');
    }

    final uri = Uri.parse(event.imageUrl);

    var fullPath = Uri.decodeComponent(uri.pathSegments.last);
    var name = fullPath.split('/').last;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('employee_portfolio_images')
        .child(employeeId!)
        .child(name);
    print(name);
    print(storageRef);

    await storageRef.delete();
  }
}
