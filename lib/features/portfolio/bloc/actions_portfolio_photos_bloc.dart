import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/features/portfolio/actions_portfolio_photos_repository.dart';

part 'actions_portfolio_photos_event.dart';
part 'actions_portfolio_photos_state.dart';

class ActionsPortfolioPhotosBloc
    extends Bloc<ActionsPortfolioPhotosEvent, ActionsPortfolioPhotosState> {
  final ActionsPortfolioPhotosRepository actionsPortfolioPhotosRepository;

  ActionsPortfolioPhotosBloc(this.actionsPortfolioPhotosRepository)
      : super(ActionsPortfolioPhotosInitial()) {
    on<CreatePortfolioPhotoEvent>((event, emit) async {
      emit(ActionsPortfolioPhotosLoadingState());
      try {
        var url = await actionsPortfolioPhotosRepository.createPhoto(event);
        emit(ActionsPortfolioPhotosLoadedState(url: url));
      } catch (e) {
        emit(ActionsPortfolioPhotosErrorState(error: e.toString()));
      }
    });

    on<DeletePortfolioPhotoEvent>((event, emit) async {
      emit(ActionsPortfolioPhotosLoadingState());
      try {
        await actionsPortfolioPhotosRepository.deletePhoto(event);
        emit(ActionsPortfolioPhotosDeletedState(url: event.imageUrl));
      } catch (e) {
        print(e.toString());
        emit(ActionsPortfolioPhotosErrorState(error: e.toString()));
      }
    });
  }
}
