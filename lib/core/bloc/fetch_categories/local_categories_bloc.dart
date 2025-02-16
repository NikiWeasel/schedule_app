import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/core/repository/local_categories_repository.dart';
import 'package:schedule_app/core/models/category.dart';

part 'local_categories_event.dart';

part 'local_categories_state.dart';

class LocalCategoriesBloc
    extends Bloc<LocalCategoriesEvent, FetchCategoriesState> {
  final LocalCategoriesRepository localCategoriesRepository;
  List<RegCategory> localCats = [];

  LocalCategoriesBloc(this.localCategoriesRepository)
      : super(LocalCategoriesInitialState()) {
    on<FetchCategoriesData>((event, emit) async {
      emit(LocalCategoriesLoadingState());
      try {
        localCats = await localCategoriesRepository.fetchCategoriesData();
        emit(LocalCategoriesLoadedState(categorys: localCats));
      } catch (e) {
        emit(LocalCategoriesErrorState(errorMessage: e.toString()));
      }
    });

    on<AddLocalCategory>((event, emit) async {
      emit(LocalCategoriesLoadingState());
      try {
        localCats = localCategoriesRepository.addLocalCategory(
            localCats, event.regulation);

        emit(LocalCategoriesLoadedState(categorys: localCats));
      } catch (e) {
        emit(LocalCategoriesErrorState(errorMessage: e.toString()));
      }
    });

    on<UpdateLocalCategory>((event, emit) async {
      emit(LocalCategoriesLoadingState());
      try {
        localCats = localCategoriesRepository.updateLocalCategory(
            localCats, event.regulation);

        emit(LocalCategoriesLoadedState(categorys: localCats));
      } catch (e) {
        emit(LocalCategoriesErrorState(errorMessage: e.toString()));
      }
    });

    on<DeleteLocalCategory>((event, emit) async {
      emit(LocalCategoriesLoadingState());
      try {
        localCats = localCategoriesRepository.deleteLocalCategory(
            localCats, event.regulation);

        emit(LocalCategoriesLoadedState(categorys: localCats));
      } catch (e) {
        emit(LocalCategoriesErrorState(errorMessage: e.toString()));
      }
    });
  }
}
