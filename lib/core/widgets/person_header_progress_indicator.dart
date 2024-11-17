import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonHeaderProgressIndicator extends StatelessWidget {
  const PersonHeaderProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            child: CircularProgressIndicator(),
          ),
          const SizedBox(
            width: 15,
          ),
          SizedBox(
            width: 75,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                    scaleY: 1.6, child: const LinearProgressIndicator()),
                const SizedBox(
                  height: 15,
                ),
                Transform.scale(
                    scaleY: 1.2, child: const LinearProgressIndicator()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
