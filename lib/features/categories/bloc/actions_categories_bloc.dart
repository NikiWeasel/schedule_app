import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/category.dart';
import 'package:schedule_app/core/models/category.dart';
import 'package:schedule_app/features/categories/actions_categories_repository.dart';

part 'actions_categories_event.dart';

part 'actions_categories_state.dart';

class ActionsCategoriesBloc
    extends Bloc<ActionsCategoriesEvent, ActionsCategoriesState> {
  final ActionsCategoriesRepository actionsCategoriesRepository;

  ActionsCategoriesBloc(this.actionsCategoriesRepository)
      : super(ActionsCategoriesInitialState()) {
    on<CreateCategoryEvent>((event, emit) async {
      emit(ActionsCategoriesLoadingState());
      try {
        await actionsCategoriesRepository.createCategory(event);
        emit(ActionsCategoriesLoadedState(cat: event.category));
      } catch (e) {
        emit(ActionsCategoriesErrorState(error: e.toString()));
      }
    });

    on<DeleteCategoryEvent>((event, emit) async {
      emit(ActionsCategoriesLoadingState());
      try {
        await actionsCategoriesRepository.deleteCategory(event);
        emit(ActionsCategoriesDeletedState(cat: event.category));
      } catch (e) {
        emit(ActionsCategoriesErrorState(error: e.toString()));
      }
    });

    on<UpdateCategoryEvent>((event, emit) async {
      emit(ActionsCategoriesLoadingState());
      try {
        await actionsCategoriesRepository.updateCategory(event);
        emit(ActionsCategoriesUpdatedState(cat: event.category));
      } catch (e) {
        emit(ActionsCategoriesErrorState(error: e.toString()));
      }
    });
  }
}
