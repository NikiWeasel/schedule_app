part of 'local_categories_bloc.dart';

@immutable
sealed class LocalCategoriesEvent {}

class FetchCategoriesData extends LocalCategoriesEvent {}

class AddLocalCategory extends LocalCategoriesEvent {
  final RegCategory regulation;

  AddLocalCategory({required this.regulation});
}

class UpdateLocalCategory extends LocalCategoriesEvent {
  final RegCategory regulation;

  UpdateLocalCategory({required this.regulation});
}

class DeleteLocalCategory extends LocalCategoriesEvent {
  final RegCategory regulation;

  DeleteLocalCategory({required this.regulation});
}
