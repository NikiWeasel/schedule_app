import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceButton extends StatelessWidget {
  const ServiceButton({super.key, required this.onClose, required this.label});

  final String label;
  final void Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            Transform.scale(
                scale: 0.8,
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: IconButton(
                      onPressed: onClose, icon: const Icon(Icons.close)),
                ))
          ],
        ),
      ),
    );
  }
}
