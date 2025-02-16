import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_categories/local_categories_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_categories/local_categories_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/features/categories/bloc/actions_categories_bloc.dart';
import 'package:schedule_app/features/categories/bloc/actions_categories_bloc.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/features/categories/view/widgets/categories_content.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionsCategoriesBloc, ActionsCategoriesState>(
      listener: (context, state) {
        if (state is ActionsCategoriesLoadingState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Загрузка...',
              duration: const Duration(seconds: 60));
        }
        if (state is ActionsCategoriesLoadedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Категория загружена!');

          context
              .read<LocalCategoriesBloc>()
              .add(AddLocalCategory(regulation: state.cat));
        }
        if (state is ActionsCategoriesUpdatedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Категория обновлена!');

          context
              .read<LocalCategoriesBloc>()
              .add(UpdateLocalCategory(regulation: state.cat));
        }
        if (state is ActionsCategoriesDeletedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Категория удалена!');

          context
              .read<LocalCategoriesBloc>()
              .add(DeleteLocalCategory(regulation: state.cat));
        }
        if (state is ActionsCategoriesErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Произошла ошибка: ${state.error}');
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          return BlocBuilder<LocalRegulationsBloc, FetchRegulationsState>(
            builder: (context, regsState) {
              return BlocBuilder<LocalCategoriesBloc, FetchCategoriesState>(
                builder: (context, localCatsState) {
                  print(localCatsState);

                  return Scaffold(
                    appBar: (localCatsState is LocalCategoriesLoadedState &&
                            userState is UserLoaded &&
                            regsState is LocalRegulationsLoadedState)
                        ? null
                        : AppBar(
                            title: const Text('Услуги'),
                          ),
                    body: Builder(
                      builder: (context) {
                        if (localCatsState is LocalCategoriesErrorState) {
                          return Center(
                            child: Text(localCatsState.errorMessage),
                          );
                        }
                        if (localCatsState is LocalCategoriesErrorState) {
                          return Center(
                            child: Text(localCatsState.errorMessage),
                          );
                        }
                        if (localCatsState is LocalCategoriesLoadedState &&
                            userState is UserLoaded &&
                            regsState is LocalRegulationsLoadedState) {
                          return CategoriesContent(
                              catList: localCatsState.categorys,
                              isAdmin: userState.user.isAdmin,
                              allRegs: regsState.regulations);
                        }
                        return const Center(
                          child: CardCircularProgressIndicator(),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
