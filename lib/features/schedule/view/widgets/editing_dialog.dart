import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/core/bloc/add_delete/actions_appointment_bloc.dart';
import 'package:schedule_app/core/bloc/fetch/fetch_appointments_bloc.dart';
import 'package:schedule_app/core/constants/saloon_services.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/features/schedule/view/widgets/service_button.dart';

class EditingDialog extends StatefulWidget {
  EditingDialog({super.key, this.appointment});

  // final bool isEditing;
  Appointment? appointment;

  @override
  State<EditingDialog> createState() => _EditingDialogState();
}

class _EditingDialogState extends State<EditingDialog> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 09, minute: 00);
  DateTime selectedDate = DateTime.now();
  String? selectedService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  List<String> selectedServices = [];
  List<int> selectedServicesDuration = [];
  int timeCounter = 0;

  late TextEditingController numberController;
  late TextEditingController nameController;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String enteredNumber = '';
  String enteredName = '';

  void createAppointment() {}

  void patchAppointment() {
    //TODO: implement
  }

  @override
  void initState() {
    nameController = TextEditingController();
    numberController = TextEditingController();

    if (widget.appointment != null) {
      numberController.text = widget.appointment!.clientNumber;
      nameController.text = widget.appointment!.clientName;
      selectedTime = TimeOfDay(
          hour: widget.appointment!.getStartTimeHours(),
          minute: widget.appointment!.getStartTimeMinutes());
      selectedDate = widget.appointment!.date;
      selectedServices = widget.appointment!.serviceName.split(' + ');
      int sum = 0;
      for (var element in selectedServices) {
        // addService(element);
        int numToAdd = services[element]!;
        selectedServicesDuration.add(numToAdd);
        sum = sum + numToAdd;
      }
      if (widget.appointment!.duration > sum) {
        var time =
            selectedServicesDuration[0] + (widget.appointment!.duration - sum);
        selectedServicesDuration[0] = time;
        timeCounter = time;
      } else {
        timeCounter = sum;
      }
    }

    super.initState();
  }

  bool _submit() {
    var isValid = _formKey.currentState!.validate();

    if (!isValid || selectedServices.isEmpty) {
      return false;
    }
    _formKey.currentState!.save();

    return true;
  }

  void resetTimeCounter() {
    timeCounter = 0;
    for (var element in selectedServicesDuration) {
      timeCounter = timeCounter + element;
    }
  }

  void addService() {
    if (selectedService != null && _controller.text != '0') {
      setState(() {
        selectedServices.add(selectedService!);
        selectedServicesDuration.add(int.parse(_controller.text));

        resetTimeCounter();
        // timeCounter = selectedServicesDuration.addAll(iterable);
      });
    }
  }

  void removeService(String service) {
    int index = selectedServices.indexOf(service);
    selectedServicesDuration.removeAt(index);
    setState(() {
      selectedServices.remove(service);
      resetTimeCounter();
    });
  }

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
      initialEntryMode: TimePickerEntryMode.inputOnly,
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

  int timeToMin(TimeOfDay timeOfDay) {
    return timeOfDay.hour * 60 + timeOfDay.minute;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchAppointmentsBloc(),
      child: Form(
        key: _formKey,
        child: Padding(
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
                          widget.appointment != null
                              ? 'Изменить запись'
                              : 'Добавить запись',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: numberController,
                          decoration: InputDecoration(
                              label: const Text('Номер'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Незаполненное поле';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            enteredNumber = value!;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              label: const Text('Имя'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Незаполненное поле';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            enteredName = value!;
                          },
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 0.4,
                      children: [
                        for (var service in selectedServices)
                          ServiceButton(
                              onClose: () {
                                removeService(service);
                              },
                              label: service)
                      ],
                    ),
                  ),
                  if (selectedServices.isNotEmpty)
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Text('Суммарное время: $timeCounter мин')),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedService,
                          hint: const Text('Выберите услугу'),
                          isExpanded: true,
                          // Для полного расширения кнопки по ширине
                          items: services.keys
                              .map<DropdownMenuItem<String>>((String key) {
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(key), // Вывод названия услуги и цены
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedService =
                                  newValue; // Установка выбранного значения
                              _controller.text = services[newValue].toString();
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
                      SizedBox(
                          width: 120,
                          child: TextFormField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: const Text('Время (мин)'),
                              // hintText: 'Имя',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: addService,
                        child: const Text('Добавить услугу')),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocProvider(
                    create: (context) =>
                        ActionsAppointmentBloc(_firebaseFirestore),
                    child: Builder(
                      builder: (context) => ElevatedButton(
                        onPressed: () {
                          var isOk = _submit();
                          if (isOk) {
                            Appointment appointment = Appointment(
                              // appointmentId: widget.appointment.appointmentId,
                              masterId: FirebaseAuth.instance.currentUser!.uid,
                              clientName: enteredName,
                              clientNumber: enteredNumber,
                              serviceName: selectedServices.join(' + '),
                              startTime: timeToMin(selectedTime),
                              duration: timeCounter,
                              date: selectedDate,
                            );
                            if (widget.appointment == null) {
                              BlocProvider.of<ActionsAppointmentBloc>(context)
                                  .add(
                                CreateAppointmentEvent(
                                    appointment: appointment),
                              );
                            } else {
                              appointment.appointmentId =
                                  widget.appointment!.appointmentId;
                              BlocProvider.of<ActionsAppointmentBloc>(context)
                                  .add(
                                UpdateAppointmentEvent(
                                    appointment: appointment),
                              );
                            }
                          }
                        },
                        child: const Text('Подтвердить'),
                      ),
                    ),
                  ),
                ])),
      ),
    );
  }
}
