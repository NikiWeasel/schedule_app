import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'actions_portfolio_photos_event.dart';

part 'actions_portfolio_photos_state.dart';

class ActionsPortfolioPhotosBloc
    extends Bloc<ActionsPortfolioPhotosEvent, ActionsPortfolioPhotosState> {
  final employeeId = FirebaseAuth.instance.currentUser?.uid;

  ActionsPortfolioPhotosBloc() : super(ActionsPortfolioPhotosInitial()) {
    on<CreatePortfolioPhotoEvent>((event, emit) async {
      emit(ActionsPortfolioPhotosLoadingState());
      try {
        var url = await _createAppointment(event);
        emit(ActionsPortfolioPhotosLoadedState(url: url));
      } catch (e) {
        emit(ActionsPortfolioPhotosErrorState(error: e.toString()));
      }
    });

    on<DeletePortfolioPhotoEvent>((event, emit) async {
      emit(ActionsPortfolioPhotosLoadingState());
      try {
        await _deleteAppointment(event);
        emit(ActionsPortfolioPhotosDeletedState());
      } catch (e) {
        emit(ActionsPortfolioPhotosErrorState(error: e.toString()));
      }
    });
  }

  Future<String> _createAppointment(CreatePortfolioPhotoEvent event) async {
    debugPrint('create');
    if (employeeId == null) {
      throw Exception('User: null');
    }
    var uuid = const Uuid();
    final name = uuid.v6();

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('employee_portfolio_images')
        .child(employeeId!)
        .child('$name.jpg');

    await storageRef.putFile(event.imageFile);
    final imageUrl = await storageRef.getDownloadURL();

    debugPrint('added photo');
    return storageRef.getDownloadURL();
  }

  Future<void> _deleteAppointment(DeletePortfolioPhotoEvent event) async {
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
