import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _colorList = [
  0xFF9A00A5, // Для Color.fromARGB(255, 154, 0, 165)
  0xFF0008A5, // Для Color.fromARGB(255, 0, 8, 165)
  0xFFFFF176,
];

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({super.key, required this.aciveColor});

  final int aciveColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late int localIndex = 0;

  late List<bool> boolList;

  // SharedPreferences instance = await SharedPreferences.getInstance();

  void setMonth() {}

  @override
  void initState() {
    // localIndex = widget.aciveIndex;

    boolList = List.generate(
      3,
      (index) {
        if (index == localIndex) {
          return true;
        }
        return false;
      },
    );
    super.initState();
  }

  void onTap(int index) {
    boolList = List.generate(
      3,
      (index) => false,
    );
    setState(() {
      boolList[index] = true;
      localIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выберите цвет сида'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < _colorList.length; i++)
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: boolList[i]
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface),
                    ),
                    Positioned(
                        top: 2.5,
                        left: 2.5,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              color: Theme.of(context).colorScheme.surface),
                        )),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: InkWell(
                        onTap: () {
                          onTap(i);
                        },
                        child: CircleAvatar(
                          backgroundColor: Color(_colorList[i]),
                        ),
                      ),
                    ),
                  ],
                )),
        ],
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              // onConfirm();
              Navigator.of(context).pop(_colorList[localIndex]);
            },
            child: const Text('Подтвердить')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.of(context).pop();
            },
            child: const Text('Отмена'))
      ],
    );
  }
}
