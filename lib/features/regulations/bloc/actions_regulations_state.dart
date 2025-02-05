part of 'actions_regulations_bloc.dart';

@immutable
sealed class ActionsRegulationsState {}

final class ActionsRegulationsInitialState extends ActionsRegulationsState {}

final class ActionsRegulationsLoadingState extends ActionsRegulationsState {}

final class ActionsRegulationsLoadedState extends ActionsRegulationsState {
  final Regulation reg;

  ActionsRegulationsLoadedState({required this.reg});
}

final class ActionsRegulationsUpdatedState extends ActionsRegulationsState {
  final Regulation reg;

  ActionsRegulationsUpdatedState({required this.reg});
}

final class ActionsRegulationsDeletedState extends ActionsRegulationsState {
  final Regulation reg;

  ActionsRegulationsDeletedState({required this.reg});
}

final class ActionsRegulationsErrorState extends ActionsRegulationsState {
  final String error;

  ActionsRegulationsErrorState({required this.error});
}
