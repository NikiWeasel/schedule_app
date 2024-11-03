import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MasterHeaderWidget extends StatelessWidget {
  const MasterHeaderWidget(
      {super.key,
      required this.title,
      this.subtitle,
      required this.onTap,
      this.imageProvider});

  final ImageProvider<Object>? imageProvider;
  final String title;
  final String? subtitle;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              foregroundImage: imageProvider,
              child: const Icon(Icons.person),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle == null
                    ? const SizedBox()
                    : Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
