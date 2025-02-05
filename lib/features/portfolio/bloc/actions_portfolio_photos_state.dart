part of 'actions_portfolio_photos_bloc.dart';

@immutable
sealed class ActionsPortfolioPhotosState {}

final class ActionsPortfolioPhotosInitial extends ActionsPortfolioPhotosState {}

final class ActionsPortfolioPhotosLoadingState
    extends ActionsPortfolioPhotosState {}

final class ActionsPortfolioPhotosLoadedState
    extends ActionsPortfolioPhotosState {
  final String url;

  ActionsPortfolioPhotosLoadedState({required this.url});
}

final class ActionsPortfolioPhotosDeletedState
    extends ActionsPortfolioPhotosState {
  final String url;

  ActionsPortfolioPhotosDeletedState({required this.url});
}

final class ActionsPortfolioPhotosErrorState
    extends ActionsPortfolioPhotosState {
  final String error;

  ActionsPortfolioPhotosErrorState({required this.error});
}
