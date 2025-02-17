import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/category.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/core/utils/vibration.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile(
      {super.key,
      required this.onLongPress,
      required this.isAdmin,
      // required this.onDelete,
      required this.category});

  final RegCategory category;
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
        title: Text(category.name),
        subtitle: Text(category.description.toString()),
        // trailing: Text('${category.cost.toString()} руб'),
        onLongPress: () {
          onHoldVibrate();
          onLongPress();
        },
      ),
    );
  }
}
