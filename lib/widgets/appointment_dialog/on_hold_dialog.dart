import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/appointment_dialog/editing_dialog.dart';

class OnHoldDialog extends StatelessWidget {
  const OnHoldDialog({super.key});

  void onEdit(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => const EditingDialog(
              isEditing: true,
            ));
  }

  void onDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                'Отменить запись?',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
              content: Text(
                'Запись будет удалена навсегда.',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              actionsAlignment: MainAxisAlignment.start,
              actions: [
                ElevatedButton(onPressed: () {}, child: Text('Подтвердить')),
                TextButton(onPressed: () {}, child: Text('Отмена'))
              ],
            ));
  }

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
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              // style: ElevatedButtonTheme.of(context).style!.copyWith(backgroundColor: Theme.of(context).colorScheme.primaryContainer),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onDelete(context);
              },
              child: Text(
                'Отменить запись',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
