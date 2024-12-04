import 'package:flutter/material.dart';

class AlertConfirmDialog extends StatelessWidget {
  const AlertConfirmDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.onConfirm});

  final String title;
  final String content;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!,
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.titleMedium!,
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text('Подтвердить')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.of(context).pop();
            },
            child: const Text('Отмена'))
      ],
    );
  }
}
