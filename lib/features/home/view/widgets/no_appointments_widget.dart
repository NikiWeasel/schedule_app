import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoAppointmentsWidget extends StatelessWidget {
  const NoAppointmentsWidget({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Пока ничего!',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
          TextButton(
              onPressed: onTap,
              child: Text('Добавить прием?',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold)))
        ],
      )),
    );
  }
}
