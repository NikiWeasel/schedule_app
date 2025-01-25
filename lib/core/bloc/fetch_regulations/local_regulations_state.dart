part of 'local_regulations_bloc.dart';

@immutable
sealed class FetchRegulationsState {}

final class LocalRegulationsInitialState extends FetchRegulationsState {}

class LocalRegulationsLoadingState extends FetchRegulationsState {}

class LocalRegulationsLoadedState extends FetchRegulationsState {
  final List<Regulation> regulations;

  LocalRegulationsLoadedState({required this.regulations});
}

class LocalRegulationsErrorState extends FetchRegulationsState {
  final String errorMessage;

  LocalRegulationsErrorState({required this.errorMessage});
}
