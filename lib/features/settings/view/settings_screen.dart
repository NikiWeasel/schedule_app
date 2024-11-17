import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:schedule_app/features/settings/view/widgets/labeled_switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // bool sliderValue = false;
  //
  // void toggleSliderValue() {
  //   setState(() {
  //     sliderValue = !sliderValue;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Настройки'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Уведомления',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                LabeledSwitch(label: 'Уведомлять при новых отзывах'),
                LabeledSwitch(label: 'Уведомлять о сессиях заранее'),
              ]))
        ]));
  }
}
