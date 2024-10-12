import 'package:flutter/material.dart';

class Appointment {
  final String master;
  final String client;
  final TimeOfDay startTime;
  final Duration duration;

  Appointment(this.master, this.client, this.startTime, this.duration);
}