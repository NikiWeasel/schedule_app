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

class RegulationsScreen extends StatelessWidget {
  const RegulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    void renew() {
      context.read<FetchRegulationsBloc>().add(FetchRegulationsData());
    }

    void onLongPress(Regulation reg, bool isAdmin) {
      if (isAdmin) {
        showModalBottomSheet(
            context: context,
            builder: (context) => RegulationDialog(regulation: reg));
      } else {
        showTopSnackBar(context, 'Нельзя редактировать услуги');
      }
    }

    Future<bool> confirmDismiss() async {
      bool wasDismissed = false;
      await showDialog(
          context: context,
          builder: (ctx) => AlertConfirmDialog(
              title: 'Удалить услугу?',
              content: 'Услуга будет удалена навсегда.',
              onConfirm: () {
                // delete();
                wasDismissed = true;
              }));
      return wasDismissed;
    }

    return BlocProvider(
      create: (context) => ActionsRegulationsBloc(firebaseFirestore),
      child: BlocBuilder<UserBloc, UserState>(
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
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Регламент'),
                        actions: [
                          IconButton(
                              onPressed: renew,
                              icon: const Icon(Icons.autorenew))
                        ],
                      ),
                      body: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        children: [
                          for (var reg in regList)
                            Dismissible(
                              direction: DismissDirection.endToStart,
                              dismissThresholds: const {
                                DismissDirection.endToStart: 0.5
                              },
                              confirmDismiss: (dis) {
                                return confirmDismiss();
                              },
                              key: ValueKey<int>(regList.indexOf(reg)),
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Theme.of(context).colorScheme.surface,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                              onDismissed: (DismissDirection direction) {
                                context.read<ActionsRegulationsBloc>().add(
                                    DeleteRegulationEvent(regulation: reg));
                                regList.remove(reg);
                              },
                              child: RegulationTile(
                                isAdmin: isAdmin,
                                onLongPress: () {
                                  onLongPress(reg, isAdmin);
                                },
                                // onDelete: () {
                                //   context.read<ActionsRegulationsBloc>().add(
                                //       DeleteRegulationEvent(regulation: reg));
                                // },
                                regulation: reg,
                              ),
                            )
                        ],
                      ),
                      floatingActionButton: isAdmin
                          ? FloatingActionButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        const RegulationDialog(
                                            regulation: null));
                              },
                              child: const Icon(Icons.add),
                            )
                          : null,
                    );
                  }
                  if (regulationsState is FetchRegulationsErrorState) {
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
