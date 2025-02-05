part of 'local_regulations_bloc.dart';

@immutable
sealed class LocalRegulationsEvent {}

class FetchRegulationsData extends LocalRegulationsEvent {}

class AddLocalRegulation extends LocalRegulationsEvent {
  final Regulation regulation;

  AddLocalRegulation({required this.regulation});
}

class UpdateLocalRegulation extends LocalRegulationsEvent {
  final Regulation regulation;

  UpdateLocalRegulation({required this.regulation});
}

class DeleteLocalRegulation extends LocalRegulationsEvent {
  final Regulation regulation;

  DeleteLocalRegulation({required this.regulation});
}
