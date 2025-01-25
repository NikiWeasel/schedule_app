import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/repository/fetch_data_repository.dart';

part 'fetch_portfolio_photos_event.dart';

part 'fetch_portfolio_photos_state.dart';

class FetchPortfolioPhotosBloc
    extends Bloc<FetchPortfolioPhotosEvent, FetchPortfolioPhotosState> {
  final FetchDataRepository fetchDataRepository;

  FetchPortfolioPhotosBloc(this.fetchDataRepository)
      : super(FetchPortfolioPhotosInitial()) {
    on<FetchPortfolioPhotosData>((event, emit) async {
      emit(FetchPortfolioPhotosLoadingState());
      try {
        var urls = await fetchDataRepository.fetchPortfolioPhotos();
        emit(FetchPortfolioPhotosLoadedState(downloadUrls: urls));
      } catch (e) {
        emit(FetchPortfolioPhotosErrorState(errorMessage: e.toString()));
      }
    });
  }
}
