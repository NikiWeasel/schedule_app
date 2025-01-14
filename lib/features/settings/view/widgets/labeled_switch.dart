import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabeledSwitch extends StatefulWidget {
  const LabeledSwitch(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged});

  final String label;
  final bool value;
  final void Function(bool) onChanged;

  // final

  @override
  State<LabeledSwitch> createState() => _LabeledSwitchState();
}

class _LabeledSwitchState extends State<LabeledSwitch> {
  bool sliderValue = false;

  @override
  void initState() {
    sliderValue = widget.value;
    super.initState();
  }

  void toggleSliderValue() {
    setState(() {
      sliderValue = !sliderValue;
    });
    widget.onChanged(sliderValue);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      radius: (0.5),
      onTap: toggleSliderValue,
      child: Row(
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
      ),
    );
  }
}
