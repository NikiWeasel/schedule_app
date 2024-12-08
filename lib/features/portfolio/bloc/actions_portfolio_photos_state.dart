part of 'actions_portfolio_photos_bloc.dart';

@immutable
sealed class ActionsPortfolioPhotosState {}

final class ActionsPortfolioPhotosInitial extends ActionsPortfolioPhotosState {}

final class ActionsPortfolioPhotosLoadingState
    extends ActionsPortfolioPhotosState {}

final class ActionsPortfolioPhotosLoadedState
    extends ActionsPortfolioPhotosState {}

final class ActionsPortfolioPhotosErrorState
    extends ActionsPortfolioPhotosState {
  final String error;

  ActionsPortfolioPhotosErrorState({required this.error});
}
