import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/repository/local_portfolio_photos_repository.dart';

part 'local_portfolio_photos_event.dart';

part 'local_portfolio_photos_state.dart';

class LocalPortfolioPhotosBloc
    extends Bloc<FetchPortfolioPhotosEvent, LocalPortfolioPhotosState> {
  final LocalPortfolioPhotosRepository localPortfolioPhotosRepository;
  List<String> localUrls = [];

  LocalPortfolioPhotosBloc(this.localPortfolioPhotosRepository)
      : super(LocalPortfolioPhotosInitial()) {
    on<FetchPortfolioPhotosData>((event, emit) async {
      emit(LocalPortfolioPhotosLoadingState());
      try {
        localUrls = await localPortfolioPhotosRepository.fetchPortfolioPhotos();
        emit(LocalPortfolioPhotosLoadedState(downloadUrls: localUrls));
      } catch (e) {
        emit(LocalPortfolioPhotosErrorState(errorMessage: e.toString()));
      }
    });

    on<AddLocalPortfolioPhoto>((event, emit) async {
      emit(LocalPortfolioPhotosLoadingState());
      try {
        localUrls = localPortfolioPhotosRepository.addLocalPortfolioPhoto(
            localUrls, event.url);

        emit(LocalPortfolioPhotosLoadedState(downloadUrls: localUrls));
      } catch (e) {
        emit(LocalPortfolioPhotosErrorState(errorMessage: e.toString()));
      }
    });

    on<DeleteLocalPortfolioPhoto>((event, emit) async {
      emit(LocalPortfolioPhotosLoadingState());
      try {
        localUrls = localPortfolioPhotosRepository.deleteLocalPortfolioPhoto(
            localUrls, event.url);

        emit(LocalPortfolioPhotosLoadedState(downloadUrls: localUrls));
      } catch (e) {
        emit(LocalPortfolioPhotosErrorState(errorMessage: e.toString()));
      }
    });
  }
}
