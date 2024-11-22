import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartEmployeeTile extends StatelessWidget {
  const ChartEmployeeTile({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
            scale: 0.2,
            child: CircleAvatar(
              backgroundColor: color,
            )),
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
  }
}
