import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/core/utils/vibration.dart';

class RegulationTile extends StatelessWidget {
  const RegulationTile(
      {super.key,
      required this.onLongPress,
      required this.isAdmin,
      // required this.onDelete,
      required this.regulation});

  final Regulation regulation;
  final bool isAdmin;

  final void Function() onLongPress;

  // final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
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
        onLongPress: () {
          onHoldVibrate();
          onLongPress();
        },
      ),
    );
  }
}
