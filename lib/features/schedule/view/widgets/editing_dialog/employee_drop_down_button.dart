import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:schedule_app/core/models/employee.dart';

class EmployeeDropDownButton extends StatefulWidget {
  const EmployeeDropDownButton({
    super.key,
    required this.employees,
    required this.onChange,
  });

  final List<Employee> employees;
  final void Function(Employee emp) onChange;

  @override
  State<EmployeeDropDownButton> createState() => _EmployeeDropDownButtonState();
}

class _EmployeeDropDownButtonState extends State<EmployeeDropDownButton> {
  late String? selectedEmployee;
  late List<String> employeeStringList;

  @override
  void initState() {
    var user = widget.employees[0];
    selectedEmployee = '${user.name} ${user.surname}';
    employeeStringList = widget.employees.map((e) {
      return '${e.name} ${e.surname}';
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text('мастеру',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        Positioned(
          left: 90,
          top: -12,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 134,
            child: DropdownButtonFormField<String>(
              value: selectedEmployee,
              hint: Text(
                'cебе',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              isExpanded: true,
              // Для полного расширения кнопки по ширине
              items: employeeStringList
                  .map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(
                    key,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedEmployee = newValue;
                });
                if (newValue == null) {
                  return;
                }
                int index = employeeStringList.indexOf(newValue);
                widget.onChange(widget.employees[index]);
              },
              dropdownColor: Colors.white,
              decoration: const InputDecoration(border: InputBorder.none),
              menuMaxHeight: 200,
            ),
          ),
        ),
      ],
    );
  }
}
