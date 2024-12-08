part of 'fetch_portfolio_photos_bloc.dart';

@immutable
sealed class FetchPortfolioPhotosState {}

final class FetchPortfolioPhotosInitial extends FetchPortfolioPhotosState {}

class FetchPortfolioPhotosLoadingState extends FetchPortfolioPhotosState {}

class FetchPortfolioPhotosLoadedState extends FetchPortfolioPhotosState {
  final List<String> downloadUrls;

  FetchPortfolioPhotosLoadedState({required this.downloadUrls});
}

class FetchPortfolioPhotosErrorState extends FetchPortfolioPhotosState {
  final String errorMessage;

  FetchPortfolioPhotosErrorState({required this.errorMessage});
}
