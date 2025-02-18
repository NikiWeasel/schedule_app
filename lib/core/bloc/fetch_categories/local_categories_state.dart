part of 'local_categories_bloc.dart';

@immutable
sealed class FetchCategoriesState {}

final class LocalCategoriesInitialState extends FetchCategoriesState {}

class LocalCategoriesLoadingState extends FetchCategoriesState {}

class LocalCategoriesLoadedState extends FetchCategoriesState {
  final List<RegCategory> categories;

  LocalCategoriesLoadedState({required this.categories});
}

class LocalCategoriesErrorState extends FetchCategoriesState {
  final String errorMessage;

  LocalCategoriesErrorState({required this.errorMessage});
}
