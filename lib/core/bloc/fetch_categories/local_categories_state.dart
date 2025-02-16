part of 'local_categories_bloc.dart';

@immutable
sealed class FetchCategoriesState {}

final class LocalCategoriesInitialState extends FetchCategoriesState {}

class LocalCategoriesLoadingState extends FetchCategoriesState {}

class LocalCategoriesLoadedState extends FetchCategoriesState {
  final List<RegCategory> categorys;

  LocalCategoriesLoadedState({required this.categorys});
}

class LocalCategoriesErrorState extends FetchCategoriesState {
  final String errorMessage;

  LocalCategoriesErrorState({required this.errorMessage});
}
