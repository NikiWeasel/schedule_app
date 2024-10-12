import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditingDialog extends StatefulWidget {
  const EditingDialog({super.key, required this.isEditing});

  final bool isEditing;

  @override
  State<EditingDialog> createState() => _EditingDialogState();
}

class _EditingDialogState extends State<EditingDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.isEditing ? 'Изменить запись' : 'Добавить запись',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Номер',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Имя',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
          ),
          TextField(),
        ],
      ),
    );
  }
}
