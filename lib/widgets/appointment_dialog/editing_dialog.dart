import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/data/saloon_services.dart';

class EditingDialog extends StatefulWidget {
  const EditingDialog({super.key, required this.isEditing});

  final bool isEditing;

  @override
  State<EditingDialog> createState() => _EditingDialogState();
}

class _EditingDialogState extends State<EditingDialog> {
  //TODO: Обернуть все в Form и сделать верификации
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  String? selectedService;

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.Hm(); // Используйте нужный формат
    return format.format(dt);
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  void pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void pickDate() async {
    final DateTime? dateTime = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));
    if (dateTime != null) {
      setState(() {
        selectedDate = dateTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            right: 8,
            bottom: 8 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 3,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      widget.isEditing ? 'Изменить запись' : 'Добавить запись',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 1.3,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Номер',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Имя',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  TextButton.icon(
                    onPressed: pickTime,
                    label: Text(
                      formatTime(selectedTime),
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    icon: const Icon(Icons.access_time_outlined),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: pickDate,
                    label: Text(
                      formatDate(selectedDate),
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedService,
                      hint: Text('Выберите услугу'),
                      isExpanded: true,
                      // Для полного расширения кнопки по ширине
                      items: services.keys
                          .map<DropdownMenuItem<String>>((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text('$key'), // Вывод названия услуги и цены
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedService =
                              newValue; // Установка выбранного значения
                        });
                      },
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      // Обертка выпадающего списка в ограниченную высоту с прокруткой
                      menuMaxHeight: 200,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(width: 120, child: TextField()),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(onPressed: () {}, child: Text('Подтвердить')),
            ]));
  }
}
