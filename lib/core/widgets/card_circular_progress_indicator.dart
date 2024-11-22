import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardCircularProgressIndicator extends StatelessWidget {
  const CardCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5)),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ));
  }
}
