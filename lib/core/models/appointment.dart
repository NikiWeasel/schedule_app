class Appointment {
  Appointment(
      {required this.master,
      required this.client,
      required this.startTime,
      required this.duration});

  final String master;
  final String client; //TODO: сделать мапу (number, name)
  final int startTime;
  final int duration;

  int getStartTimeMinutes() {
    double time = startTime / 60;
    int hours = time.toInt();
    int minutes = ((time - hours) * 10).round();
    return minutes;
  }

  int getStartTimeHours() {
    double time = startTime / 60;
    int hours = time.toInt();
    return hours;
  }

  String getFormattedStartTime() {
    double time = startTime.toDouble();
    if (time >= 60) {
      time = time / 60;
    }

    int hours = time.toInt();
    int minutes = ((time - hours) * 10).round();

    String formattedHours = hours.toString();
    String formattedMinutes = minutes.toString();
    if (formattedHours.length == 1) {
      formattedHours = '0$formattedHours';
    }
    if (formattedMinutes.length == 1) {
      formattedMinutes = '0$formattedMinutes';
    }
    return '$formattedHours:$formattedMinutes';
  }

  String getFormattedEndTime() {
    double time = (startTime + duration).toDouble();
    if (time >= 60) {
      time = time / 60;
    }

    int hours = time.toInt();
    int minutes = ((time - hours).toDouble() * 60).toInt();

    String formattedHours = hours.toString();
    String formattedMinutes = minutes.toString();

    if (formattedHours.length == 1) {
      formattedHours = '0$formattedHours';
    }
    if (formattedMinutes.length == 1) {
      formattedMinutes = '0$formattedMinutes';
    }
    return '$formattedHours:$formattedMinutes';
  }

  String getFormattedDuration() {
    double time = duration.toDouble();
    if (time >= 60) {
      time = time / 60;
    } else {
      return '${time.toInt()} мин';
    }

    int hours = time.toInt();
    int minutes = ((time - hours).toDouble() * 60).toInt();

    String formattedDuration = '';
    if (hours == 0) {
      formattedDuration = '$minutes мин';
    }
    if (minutes == 0) {
      formattedDuration = '$hours ч';
    } else {
      formattedDuration = '$hours ч $minutes мин';
    }
    return formattedDuration;
  }
}
