import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/features/profile/view/widgets/employee_profile.dart';

class EmployeeProfileWidget extends StatefulWidget {
  const EmployeeProfileWidget(
      {super.key, required this.employee, this.isAlwaysReadOnly = false});

  final Employee employee;
  final bool? isAlwaysReadOnly;

  @override
  State<EmployeeProfileWidget> createState() => _EmployeeProfileWidgetState();
}

class _EmployeeProfileWidgetState extends State<EmployeeProfileWidget> {
  @override
  Widget build(BuildContext context) {
    var dialogWidth = MediaQuery.of(context).size.width - 10;

    return AlertDialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.all(10),
      // Уменьшаем отступы до 10
      titlePadding: const EdgeInsets.all(10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Transform.scale(scale: 1.3, child: const Icon(Icons.close)),
            // highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Профиль Vteme',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      content: SizedBox(
          width: dialogWidth,
          child: EmployeeProfile(
            employee: widget.employee,
            isAlwaysReadOnly: widget.isAlwaysReadOnly,
          )),
    );
  }
}
