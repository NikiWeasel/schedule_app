import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

void _vibrate() async {
  if ((await Vibration.hasVibrator() ?? false) &&
      (await Vibration.hasAmplitudeControl() ?? false)) {
    Vibration.vibrate(amplitude: 64, duration: 250);
  }
}

void showTopSnackBar(
  context,
  String message, {
  Duration? duration,
}) {
  _vibrate();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.horizontal,
      duration: duration ?? const Duration(milliseconds: 1500),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height -
              170 -
              MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0),
      behavior: SnackBarBehavior.floating,
      content: Center(
        child: Text('$message',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white)),
      ),
    ),
  );
}
