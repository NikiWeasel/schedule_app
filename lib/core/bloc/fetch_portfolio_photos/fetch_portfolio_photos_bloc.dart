import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'fetch_portfolio_photos_event.dart';

part 'fetch_portfolio_photos_state.dart';

class FetchPortfolioPhotosBloc
    extends Bloc<FetchPortfolioPhotosEvent, FetchPortfolioPhotosState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FetchPortfolioPhotosBloc() : super(FetchPortfolioPhotosInitial()) {
    on<FetchPortfolioPhotosData>(_onFetchPortfolioPhotos);
  }

  Future<void> _onFetchPortfolioPhotos(FetchPortfolioPhotosData event,
      Emitter<FetchPortfolioPhotosState> emit) async {
    emit(FetchPortfolioPhotosLoadingState());

    try {
      final employeeId = _firebaseAuth.currentUser?.uid;
      if (employeeId == null) {
        throw Exception('User: null');
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('employee_portfolio_images')
          .child(employeeId);
      final listResult = await storageRef.listAll();

      List<String> downloadUrls = await Future.wait(
        listResult.items.map((item) async => await item.getDownloadURL()),
      );

      emit(FetchPortfolioPhotosLoadedState(downloadUrls: downloadUrls));
    } catch (e) {
      emit(FetchPortfolioPhotosErrorState(errorMessage: e.toString()));
    }
  }
}
