import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/employee.dart';

class EmployeesSelectionDialog extends StatefulWidget {
  const EmployeesSelectionDialog(
      {super.key, required this.employeeList, required this.empBoolList});

  final List<Employee> employeeList;
  final List<bool> empBoolList;

  @override
  State<EmployeesSelectionDialog> createState() =>
      _EmployeesSelectionDialogState();
}

class _EmployeesSelectionDialogState extends State<EmployeesSelectionDialog> {
  late List<Employee> defaultEmployeeList;
  late List<bool> defaultEmpBoolList;

  List<Employee> getSelectedEmployeeList() {
    List<Employee> selected = [];
    for (int i = 0; i < widget.empBoolList.length; i++) {
      if (widget.empBoolList[i]) {
        selected.add(widget.employeeList[i]);
      }
    }
    return selected;
  }

  @override
  void initState() {
    defaultEmployeeList = List.from(widget.employeeList);
    defaultEmpBoolList = List.from(widget.empBoolList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выберите мастеров'),
      content: SizedBox(
        height: 350,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < widget.employeeList.length; i++)
                CheckboxListTile(
                    title: Text(
                        '${widget.employeeList[i].name} ${widget.employeeList[i].surname}'),
                    value: widget.empBoolList[i],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        widget.empBoolList[i] = value;
                      });
                    }),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(getSelectedEmployeeList());
            },
            child: const Text('Подтвердить')),
        TextButton(
            onPressed: () {
              setState(() {
                widget.empBoolList.setAll(0, defaultEmpBoolList);
              });
              Navigator.of(context).pop(defaultEmployeeList);
            },
            child: const Text('Отмена')),
      ],
    );
  }
}
