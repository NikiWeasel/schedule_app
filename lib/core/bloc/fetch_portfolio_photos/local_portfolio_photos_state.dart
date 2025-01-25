part of 'local_portfolio_photos_bloc.dart';

@immutable
sealed class LocalPortfolioPhotosState {}

final class LocalPortfolioPhotosInitial extends LocalPortfolioPhotosState {}

class LocalPortfolioPhotosLoadingState extends LocalPortfolioPhotosState {}

class LocalPortfolioPhotosLoadedState extends LocalPortfolioPhotosState {
  final List<String> downloadUrls;

  LocalPortfolioPhotosLoadedState({required this.downloadUrls});
}

class LocalPortfolioPhotosErrorState extends LocalPortfolioPhotosState {
  final String errorMessage;

  LocalPortfolioPhotosErrorState({required this.errorMessage});
}
