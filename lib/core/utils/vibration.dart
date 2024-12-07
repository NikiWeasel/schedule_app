import 'package:vibration/vibration.dart';

void onHoldVibrate() async {
  if ((await Vibration.hasVibrator() ?? false) &&
      (await Vibration.hasAmplitudeControl() ?? false)) {
    Vibration.vibrate(amplitude: 32, duration: 50);
  }
}
