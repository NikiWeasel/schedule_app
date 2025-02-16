part of 'actions_categories_bloc.dart';

@immutable
sealed class ActionsCategoriesState {}

final class ActionsCategoriesInitialState extends ActionsCategoriesState {}

final class ActionsCategoriesLoadingState extends ActionsCategoriesState {}

final class ActionsCategoriesLoadedState extends ActionsCategoriesState {
  final RegCategory cat;

  ActionsCategoriesLoadedState({required this.cat});
}

final class ActionsCategoriesUpdatedState extends ActionsCategoriesState {
  final RegCategory cat;

  ActionsCategoriesUpdatedState({required this.cat});
}

final class ActionsCategoriesDeletedState extends ActionsCategoriesState {
  final RegCategory cat;

  ActionsCategoriesDeletedState({required this.cat});
}

final class ActionsCategoriesErrorState extends ActionsCategoriesState {
  final String error;

  ActionsCategoriesErrorState({required this.error});
}
