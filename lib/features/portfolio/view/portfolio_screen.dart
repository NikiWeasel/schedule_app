import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_portfolio_photos/local_portfolio_photos_bloc.dart';
import 'package:schedule_app/features/portfolio/bloc/actions_portfolio_photos_bloc.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/portfolio/view/widgets/portfolio_content.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/features/regulations/bloc/actions_regulations_bloc.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionsPortfolioPhotosBloc,
        ActionsPortfolioPhotosState>(
      listener: (context, state) {
        if (state is ActionsPortfolioPhotosLoadingState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Загрузка...');
        }
        if (state is ActionsPortfolioPhotosLoadedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Фото сохранено!');

          context
              .read<LocalPortfolioPhotosBloc>()
              .add(AddLocalPortfolioPhoto(url: state.url));
        }
        if (state is ActionsPortfolioPhotosDeletedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Фото удалено!');

          context
              .read<LocalPortfolioPhotosBloc>()
              .add(DeleteLocalPortfolioPhoto(url: state.url));
        }

        if (state is ActionsPortfolioPhotosErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Произошла ошибка: ${state.error}');
        }
      },
      child: BlocBuilder<LocalPortfolioPhotosBloc, LocalPortfolioPhotosState>(
        builder: (context, portfolioState) {
          if (portfolioState is LocalPortfolioPhotosLoadingState) {
            return const Center(
              child: CardCircularProgressIndicator(),
            );
          }
          if (portfolioState is LocalPortfolioPhotosLoadedState) {
            List<String> imageUrlList = portfolioState.downloadUrls;

            return PortfolioContent(imageUrlList: imageUrlList);
          }
          return const Center(
            child: CardCircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
