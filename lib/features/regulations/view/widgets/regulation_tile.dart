import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/regulation.dart';

import 'package:schedule_app/core/widgets/alert_confirm_dialog.dart';

class RegulationTile extends StatelessWidget {
  const RegulationTile(
      {super.key,
      required this.onLongPress,
      required this.isAdmin,
      required this.onDelete,
      required this.regulation});

  final Regulation regulation;
  final bool isAdmin;

  final void Function() onLongPress;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    void onDeleteButton(void Function() delete) {
      showDialog(
          context: context,
          builder: (ctx) => AlertConfirmDialog(
              title: 'Удалить услугу?',
              content: 'Услуга будет удалена навсегда.',
              onConfirm: () {
                delete();
              }));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          1,
        ),
        title: Text(regulation.name),
        subtitle: Text('${regulation.duration.toString()} мин'),
        trailing: Text('${regulation.cost.toString()} руб'),
        leading: isAdmin
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  onDeleteButton(onDelete);
                })
            : null,
        onLongPress: onLongPress,
      ),
    );
  }
}
