import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/features/regulations/view/widgets/regulation_dialog.dart';
import 'package:schedule_app/features/regulations/view/widgets/regulation_tile.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/core/widgets/alert_confirm_dialog.dart';
import 'package:schedule_app/features/regulations/bloc/actions_regulations_bloc.dart';

class RegulationsContent extends StatefulWidget {
  const RegulationsContent(
      {super.key, required this.regList, required this.isAdmin});

  final List<Regulation> regList;
  final bool isAdmin;

  @override
  State<RegulationsContent> createState() => _RegulationsContentState();
}

class _RegulationsContentState extends State<RegulationsContent> {
  void renew() {
    context.read<LocalRegulationsBloc>().add(FetchRegulationsData());
  }

  void onLongPress(Regulation reg, bool isAdmin) {
    if (isAdmin) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => RegulationDialog(
                regulation: reg,
              ));
    } else {
      showTopSnackBar(context, 'Нельзя редактировать услуги');
    }
  }

  Future<bool> confirmDismiss(Regulation reg) async {
    bool wasDismissed = false;
    await showDialog(
        context: context,
        builder: (ctx) => AlertConfirmDialog(
            title: 'Удалить услугу?',
            content: 'Услуга будет удалена навсегда.',
            onConfirm: () {
              context
                  .read<ActionsRegulationsBloc>()
                  .add(DeleteRegulationEvent(regulation: reg));
              wasDismissed = false;
            }));
    return wasDismissed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Услуги'),
        actions: [
          IconButton(
              onPressed: () {
                context.push('/categories');
              },
              icon: const Icon(Icons.category)),
          IconButton(onPressed: renew, icon: const Icon(Icons.autorenew))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: [
          for (var reg in widget.regList)
            widget.isAdmin
                ? Dismissible(
                    direction: DismissDirection.endToStart,
                    dismissThresholds: const {DismissDirection.endToStart: 0.5},
                    confirmDismiss: (dis) {
                      return confirmDismiss(reg);
                    },
                    key: ValueKey<int>(widget.regList.indexOf(reg)),
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
                    onDismissed: (DismissDirection direction) {},
                    child: RegulationTile(
                      isAdmin: widget.isAdmin,
                      onLongPress: () {
                        onLongPress(reg, widget.isAdmin);
                      },
                      regulation: reg,
                    ),
                  )
                : RegulationTile(
                    isAdmin: widget.isAdmin,
                    onLongPress: () {
                      onLongPress(reg, widget.isAdmin);
                    },
                    regulation: reg,
                  ),
        ],
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const RegulationDialog(
                          regulation: null,
                        ));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
