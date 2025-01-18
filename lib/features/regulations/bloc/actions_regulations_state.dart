part of 'actions_regulations_bloc.dart';

@immutable
sealed class ActionsRegulationsState {}

final class ActionsRegulationsInitialState extends ActionsRegulationsState {}

final class ActionsRegulationsLoadingState extends ActionsRegulationsState {}

final class ActionsRegulationsLoadedState extends ActionsRegulationsState {}

final class ActionsRegulationsUpdatedState extends ActionsRegulationsState {}

final class ActionsRegulationsDeletedState extends ActionsRegulationsState {}

final class ActionsRegulationsErrorState extends ActionsRegulationsState {
  final String error;

  ActionsRegulationsErrorState({required this.error});
}
