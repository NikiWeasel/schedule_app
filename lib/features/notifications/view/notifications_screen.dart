import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';

import 'package:schedule_app/features/portfolio/bloc/actions_portfolio_photos_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
