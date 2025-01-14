import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorTile extends StatelessWidget {
  const ColorTile({super.key, required this.activeColor, required this.onTap});

  final int activeColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      radius: (0.5),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Color(activeColor),
            ),
            const SizedBox(
              width: 8,
            ),
            Text('Сид темы', style: Theme.of(context).textTheme.bodyLarge!),
          ],
        ),
      ),
    );
  }
}
