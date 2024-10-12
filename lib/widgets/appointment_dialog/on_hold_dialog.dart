import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/appointment_dialog/editing_dialog.dart';

class OnHoldDialog extends StatelessWidget {
  const OnHoldDialog({super.key});

  void onEdit(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        builder: (ctx) => const EditingDialog(
              isEditing: true,
            ));
  }

  void onDelete() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onEdit(context);
              },
              child: Text(
                'Редактировать запись',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDelete,
              child: Text(
                'Отменить запись',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
