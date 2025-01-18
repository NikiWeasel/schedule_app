import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/fetch_regulations_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/fetch_regulations_bloc.dart';
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
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        return BlocBuilder<ActionsRegulationsBloc, ActionsRegulationsState>(
          builder: (context, actionsState) {
            return BlocBuilder<FetchRegulationsBloc, FetchRegulationsState>(
              builder: (context, regulationsState) {
                if (regulationsState is FetchRegulationsLoadingState) {
                  return const Center(
                    child: CardCircularProgressIndicator(),
                  );
                }
                if (regulationsState is FetchRegulationsLoadedState &&
                    userState is UserLoaded) {
                  var regList = regulationsState.regulations;
                  bool isAdmin = userState.user.isAdmin;
                  return RegulationsContent(
                    regList: regList,
                    isAdmin: isAdmin,
                  );
                }
                if (regulationsState is FetchRegulationsErrorState) {
                  return Center(
                    child: Center(
                        child: Text(
                      'Error: ${regulationsState.errorMessage}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Theme.of(context).colorScheme.error),
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
    );
  }
}
