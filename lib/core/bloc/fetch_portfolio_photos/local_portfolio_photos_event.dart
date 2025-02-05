part of 'local_portfolio_photos_bloc.dart';

@immutable
sealed class FetchPortfolioPhotosEvent {}

class FetchPortfolioPhotosData extends FetchPortfolioPhotosEvent {}

class AddLocalPortfolioPhoto extends FetchPortfolioPhotosEvent {
  final String url;

  AddLocalPortfolioPhoto({required this.url});
}

class DeleteLocalPortfolioPhoto extends FetchPortfolioPhotosEvent {
  final String url;

  DeleteLocalPortfolioPhoto({required this.url});
}
