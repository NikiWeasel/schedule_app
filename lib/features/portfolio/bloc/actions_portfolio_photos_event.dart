part of 'actions_portfolio_photos_bloc.dart';

@immutable
sealed class ActionsPortfolioPhotosEvent {}

class CreatePortfolioPhotoEvent extends ActionsPortfolioPhotosEvent {
  final File imageFile;

  CreatePortfolioPhotoEvent({required this.imageFile});
}

class DeletePortfolioPhotoEvent extends ActionsPortfolioPhotosEvent {
  final String imageUrl;

  DeletePortfolioPhotoEvent({required this.imageUrl});
}
