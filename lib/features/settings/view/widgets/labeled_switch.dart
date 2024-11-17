import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabeledSwitch extends StatefulWidget {
  const LabeledSwitch({super.key, required this.label});

  final String label;

  // final

  @override
  State<LabeledSwitch> createState() => _LabeledSwitchState();
}

class _LabeledSwitchState extends State<LabeledSwitch> {
  bool sliderValue = false;

  void toggleSliderValue() {
    setState(() {
      sliderValue = !sliderValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.7,
          child: Switch(
              value: sliderValue,
              onChanged: (value) {
                toggleSliderValue();
              }),
        ),
        Text(widget.label, style: Theme.of(context).textTheme.bodyLarge!),
      ],
    );
  }
}
