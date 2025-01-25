import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late List<Regulation> regulationsList;

  Regulation? _oldReg;
  late Regulation _newReg;

  @override
  void initState() {
    regulationsList = widget.regList;
    super.initState();
  }

  void renew() {
    context.read<LocalRegulationsBloc>().add(FetchRegulationsData());
  }

  void onLongPress(Regulation reg, bool isAdmin) {
    if (isAdmin) {
      showModalBottomSheet(
          context: context,
          builder: (context) => RegulationDialog(
                regulation: reg,
                editRegTable: setRegTableValues,
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
              // delete();
              context
                  .read<ActionsRegulationsBloc>()
                  .add(DeleteRegulationEvent(regulation: reg));
              deleteRegTable(reg);
              wasDismissed = false;
            }));
    return wasDismissed;
  }

  void editRegTable({Regulation? oldReg, required Regulation newReg}) {
    if (oldReg == null) {
      setState(() {
        regulationsList.add(newReg);
      });
    } else {
      setState(() {
        var index = regulationsList.indexOf(oldReg);
        regulationsList.removeAt(index);
        regulationsList.insert(index, newReg);
      });
    }
  }

  void deleteRegTable(Regulation appo) {
    setState(() {
      regulationsList.remove(appo);
    });
  }

  void setRegTableValues({Regulation? oldReg, required Regulation newReg}) {
    _newReg = newReg;
    _oldReg = oldReg;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionsRegulationsBloc, ActionsRegulationsState>(
      listener: (context, state) {
        if (state is ActionsRegulationsLoadingState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Загрузка...');
        }
        if (state is ActionsRegulationsLoadedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          editRegTable(newReg: _newReg, oldReg: null);
          showTopSnackBar(context, 'Услуга загружена!');
        }
        if (state is ActionsRegulationsUpdatedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          editRegTable(newReg: _newReg, oldReg: _oldReg);
          showTopSnackBar(context, 'Услуга обновлена!');
        }
        if (state is ActionsRegulationsDeletedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Услуга удалена!');
        }
        if (state is ActionsRegulationsErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Произошла ошибка: ${state.error}');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Услуги'),
          actions: [
            IconButton(onPressed: renew, icon: const Icon(Icons.autorenew))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          children: [
            for (var reg in regulationsList)
              Dismissible(
                direction: DismissDirection.endToStart,
                dismissThresholds: const {DismissDirection.endToStart: 0.5},
                confirmDismiss: (dis) {
                  return confirmDismiss(reg);
                },
                key: ValueKey<int>(regulationsList.indexOf(reg)),
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
                  // context
                  //     .read<ActionsRegulationsBloc>()
                  //     .add(DeleteRegulationEvent(regulation: reg));
                  // regulationsList.remove(reg);
                },
                child: RegulationTile(
                  isAdmin: widget.isAdmin,
                  onLongPress: () {
                    onLongPress(reg, widget.isAdmin);
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
        floatingActionButton: widget.isAdmin
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => RegulationDialog(
                          regulation: null, editRegTable: setRegTableValues));
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
