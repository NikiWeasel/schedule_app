import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/regulation.dart';

class RegsDialog extends StatefulWidget {
  const RegsDialog(
      {super.key, required this.regsList, required this.regsBoolList});

  final List<Regulation> regsList;
  final List<bool> regsBoolList;

  @override
  State<RegsDialog> createState() => _RegsDialogState();
}

class _RegsDialogState extends State<RegsDialog> {
  late List<Regulation> defaultRegList;
  late List<bool> defaultRegBoolList;

  List<String> getSelectedRegsList() {
    List<String> selectedRegsIds = [];
    for (int i = 0; i < widget.regsBoolList.length; i++) {
      if (widget.regsBoolList[i]) {
        selectedRegsIds.add(widget.regsList[i].id!);
      }
    }
    return selectedRegsIds;
  }

  @override
  void initState() {
    defaultRegList = List.from(widget.regsList);
    defaultRegBoolList = List.from(widget.regsBoolList);

    if (defaultRegList.any(
      (element) => element.id == null,
    )) {
      context.read<LocalRegulationsBloc>().add(FetchRegulationsData());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выберите услуги'),
      content: SizedBox(
        height: 350,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < widget.regsList.length; i++)
                CheckboxListTile(
                    title: Text('${widget.regsList[i].name}'),
                    value: widget.regsBoolList[i],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        widget.regsBoolList[i] = value;
                      });
                    }),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(getSelectedRegsList());
            },
            child: const Text('Подтвердить')),
        TextButton(
            onPressed: () {
              List<String> defIds = defaultRegList
                  .where((e) => e.id != null)
                  .map((e) => e.id!)
                  .toList();

              Navigator.of(context).pop(defIds);
            },
            child: const Text('Отмена')),
      ],
    );
  }
}
