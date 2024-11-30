part of 'fetch_regulations_bloc.dart';

@immutable
sealed class FetchRegulationsState {}

final class FetchRegulationsInitialState extends FetchRegulationsState {}

class FetchRegulationsLoadingState extends FetchRegulationsState {}

class FetchRegulationsLoadedState extends FetchRegulationsState {
  final List<Regulation> regulations;

  FetchRegulationsLoadedState({required this.regulations});
}

class FetchRegulationsErrorState extends FetchRegulationsState {
  final String errorMessage;

  FetchRegulationsErrorState({required this.errorMessage});
}
