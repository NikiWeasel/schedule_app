part of 'actions_categories_bloc.dart';

@immutable
sealed class ActionsCategoriesEvent {}

class CreateCategoryEvent extends ActionsCategoriesEvent {
  final RegCategory category;

  CreateCategoryEvent({required this.category});
}

class DeleteCategoryEvent extends ActionsCategoriesEvent {
  final RegCategory category;

  DeleteCategoryEvent({required this.category});
}

class UpdateCategoryEvent extends ActionsCategoriesEvent {
  final RegCategory category;

  UpdateCategoryEvent({required this.category});
}
