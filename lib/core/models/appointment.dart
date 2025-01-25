class Appointment {
  Appointment({
    this.appointmentId,
    required this.masterId,
    required this.clientName,
    required this.clientNumber,
    required this.serviceName,
    required this.duration,
    required this.date,
  });

  String? appointmentId;
  String masterId;
  final String clientName;
  final String clientNumber;
  final String serviceName;
  final int duration;
  final DateTime date;

  String getFormattedStartTime() {
    int hours = date.hour;
    int minutes = date.minute;

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
    double time = duration.toDouble();
    if (time >= 60) {
      time = time / 60;
    }
    Duration _duration = Duration(minutes: duration);
    var endTime = date.add(_duration);

    int hours = endTime.hour;
    int minutes = endTime.minute;

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
    int minutes = ((time - hours) * 60).toInt();

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
