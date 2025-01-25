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

  LocalPortfolioPhotosBloc(this.localPortfolioPhotosRepository)
      : super(LocalPortfolioPhotosInitial()) {
    on<FetchPortfolioPhotosData>((event, emit) async {
      emit(LocalPortfolioPhotosLoadingState());
      try {
        var urls = await localPortfolioPhotosRepository.fetchPortfolioPhotos();
        emit(LocalPortfolioPhotosLoadedState(downloadUrls: urls));
      } catch (e) {
        emit(LocalPortfolioPhotosErrorState(errorMessage: e.toString()));
      }
    });
  }
}
