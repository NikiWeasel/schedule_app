import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/regulations/view/widgets/regulation_dialog.dart';
import 'package:schedule_app/features/regulations/view/widgets/regulation_tile.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:schedule_app/features/regulations/bloc/actions_regulations_bloc.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/core/widgets/alert_confirm_dialog.dart';
import 'package:schedule_app/features/regulations/view/widgets/regulations_content.dart';

class RegulationsScreen extends StatelessWidget {
  const RegulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionsRegulationsBloc, ActionsRegulationsState>(
      listener: (context, state) {
        if (state is ActionsRegulationsLoadingState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Загрузка...',
              duration: const Duration(seconds: 60));
        }
        if (state is ActionsRegulationsLoadedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Услуга загружена!');

          context
              .read<LocalRegulationsBloc>()
              .add(AddLocalRegulation(regulation: state.reg));
        }
        if (state is ActionsRegulationsUpdatedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Услуга обновлена!');

          context
              .read<LocalRegulationsBloc>()
              .add(UpdateLocalRegulation(regulation: state.reg));
        }
        if (state is ActionsRegulationsDeletedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Услуга удалена!');

          context
              .read<LocalRegulationsBloc>()
              .add(DeleteLocalRegulation(regulation: state.reg));
        }
        if (state is ActionsRegulationsErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Произошла ошибка: ${state.error}');
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          return BlocBuilder<ActionsRegulationsBloc, ActionsRegulationsState>(
            builder: (context, actionsState) {
              return BlocBuilder<LocalRegulationsBloc, FetchRegulationsState>(
                builder: (context, regulationsState) {
                  if (regulationsState is LocalRegulationsLoadingState) {
                    return const Center(
                      child: CardCircularProgressIndicator(),
                    );
                  }
                  if (regulationsState is LocalRegulationsLoadedState &&
                      userState is UserLoaded) {
                    var regList = regulationsState.regulations;
                    bool isAdmin = userState.user.isAdmin;
                    return RegulationsContent(
                      regList: regList,
                      isAdmin: isAdmin,
                    );
                  }
                  if (regulationsState is LocalRegulationsErrorState) {
                    return Center(
                      child: Center(
                          child: Text(
                        'Error: ${regulationsState.errorMessage}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.error),
                      )),
                    );
                  }
                  return const Center(
                    child: CardCircularProgressIndicator(),
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
