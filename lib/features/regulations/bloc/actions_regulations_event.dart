part of 'actions_regulations_bloc.dart';

@immutable
sealed class ActionsRegulationsEvent {}

class CreateRegulationEvent extends ActionsRegulationsEvent {
  final Regulation regulation;

  CreateRegulationEvent({required this.regulation});
}

class DeleteRegulationEvent extends ActionsRegulationsEvent {
  final Regulation regulation;

  DeleteRegulationEvent({required this.regulation});
}

class UpdateRegulationEvent extends ActionsRegulationsEvent {
  final Regulation regulation;

  UpdateRegulationEvent({required this.regulation});
}
