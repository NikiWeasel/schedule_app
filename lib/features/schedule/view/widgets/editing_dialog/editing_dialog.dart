import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_appointments/fetch_appointments_bloc.dart';
import 'package:schedule_app/core/constants/saloon_services.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/features/home/view/widgets/employees_selection_dialog.dart';
import 'package:schedule_app/features/schedule/view/widgets/service_button.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'employee_drop_down_button.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';

class EditingDialog extends StatefulWidget {
  EditingDialog(
      {super.key,
      this.appointment,
      required this.curentDate,
      required this.editAppoTable,
      required this.employees,
      required this.services});

  // final bool isEditing;
  final DateTime curentDate;
  final void Function({Appointment? oldAppo, required Appointment newAppo})
      editAppoTable;
  Appointment? appointment;
  final Map<String, int> services;
  final List<Employee>? employees;

  @override
  State<EditingDialog> createState() => _EditingDialogState();
}

class _EditingDialogState extends State<EditingDialog> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 00);
  late DateTime selectedDate;
  String? selectedService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _serviceFormKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  List<String> selectedServices = [];
  List<int> selectedServicesDuration = [];
  int timeCounter = 0;

  Employee? selectedEmployee;

  bool isServicesEmptyError = false;

  late TextEditingController numberController;
  late TextEditingController nameController;

  String enteredNumber = '';
  String enteredName = '';

  @override
  void initState() {
    context.read<FetchAppointmentsBloc>().add(FetchAppointmentsData());

    selectedDate = widget.curentDate;
    selectedEmployee = widget.employees?[0];

    nameController = TextEditingController();
    numberController = TextEditingController();

    if (widget.appointment != null) {
      numberController.text = widget.appointment!.clientNumber;
      nameController.text = widget.appointment!.clientName;
      selectedTime = TimeOfDay(
          hour: widget.appointment!.date.hour,
          minute: widget.appointment!.date.minute);
      selectedDate = widget.appointment!.date;
      selectedServices = widget.appointment!.serviceName.split(' + ');

      int sum = 0;

      for (var element in selectedServices) {
        // addService(element);
        int numToAdd = widget.services[element]!;
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

  @override
  void dispose() {
    numberController.dispose();
    _controller.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool isOverlapping(
      Appointment newAppointment, List<Appointment> appointments) {
    var startTime =
        (newAppointment.date.hour * 60) + newAppointment.date.minute;

    var newEnd = startTime + newAppointment.duration;
    var newStart = startTime;

    for (var appo in appointments) {
      var start = startTime;
      var end = start + appo.duration;
      // Проверка на пересечение
      if ((newStart > start && newStart < end) ||
          (newEnd > start && newEnd < end)) {
        if (appo.appointmentId != newAppointment.appointmentId) {
          return true; // Пересечение найдено
        }
      }
    }
    return false; // Нет пересечений
  }

  bool isOverWorkingTime(Appointment newAppointment) {
    var startTime =
        (newAppointment.date.hour * 60) + newAppointment.date.minute;

    var newEnd = startTime + newAppointment.duration;
    var newStart = startTime;
    var start = 600;
    var end = 1200;

    if ((newStart < start || newStart > end) || (newEnd > end)) {
      return true;
    }

    return false;
  }

  bool _submit() {
    var isValid = _formKey.currentState!.validate();

    if (selectedServices.isEmpty) {
      setState(() {
        isServicesEmptyError = true;
      });
    }
    if (!isValid || selectedServices.isEmpty) {
      return false;
    }
    _formKey.currentState!.save();

    return true;
  }

  void onConfirm(
      void Function(Appointment appo) updateAppo,
      void Function(Appointment appo) createAppo,
      List<Appointment> appointments) {
    if (!_submit()) {
      return;
    }
    Appointment appointment = Appointment(
      masterId: FirebaseAuth.instance.currentUser!.uid,
      clientName: enteredName,
      clientNumber: enteredNumber,
      serviceName: selectedServices.join(' + '),
      duration: timeCounter,
      date: getDateTime(selectedDate, selectedTime),
    );

    if (widget.appointment == null) {
      if (widget.employees != null) {
        appointment.masterId = selectedEmployee!.employeeId;
      }

      var activeUserAppos = appointments
          .where((appo) => appo.masterId == appointment.masterId)
          .toList();

      if (isOverlapping(appointment, activeUserAppos)) {
        print('overlap1');
        showTopSnackBar(context, 'Пересечение с другой записью');
        return;
      }
      if (isOverWorkingTime(appointment)) {
        print('over working time');
        showTopSnackBar(context, 'Запись вне рабочего времени');
        return;
      }

      createAppo(appointment);
      widget.editAppoTable(newAppo: appointment);
      Navigator.pop(context);
    } else {
      appointment.appointmentId = widget.appointment!.appointmentId;

      appointment.masterId = widget.appointment!.masterId;

      var activeUserAppos = appointments
          .where((appo) => appo.masterId == appointment.masterId)
          .toList();

      if (isOverlapping(appointment, activeUserAppos)) {
        print('overlap2');
        showTopSnackBar(context, 'Пересечение с другой записью');
        return;
      }
      if (isOverWorkingTime(appointment)) {
        print('over working time');
        showTopSnackBar(context, 'Запись вне рабочего времени');
        return;
      }

      updateAppo(appointment);
      widget.editAppoTable(oldAppo: widget.appointment!, newAppo: appointment);
      Navigator.pop(context);
    }
  }

  void resetTimeCounter() {
    timeCounter = 0;
    for (var element in selectedServicesDuration) {
      timeCounter = timeCounter + element;
    }
  }

  void addService() {
    var isValid = _serviceFormKey.currentState!.validate();

    if (isValid) {
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
    final format = DateFormat.Hm();
    return format.format(dt);
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  void pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 00),
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
        initialDate: widget.curentDate,
        currentDate: widget.curentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));
    if (dateTime != null) {
      setState(() {
        selectedDate = dateTime;
      });
    }
  }

  DateTime getDateTime(DateTime date, TimeOfDay time) {
    var newDate =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return newDate;
  }

  void onEmpDropButtonChange(Employee emp) {
    setState(() {
      selectedEmployee = emp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                if (widget.employees != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: EmployeeDropDownButton(
                          employees: widget.employees!,
                          onChange: onEmpDropButtonChange,
                        )),
                  ),
                SizedBox(
                  height: widget.employees != null ? 16 : 8,
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
                  height: 5,
                ),
                if (selectedServices.isEmpty && isServicesEmptyError)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Нет услуг',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedService,
                        hint: const Text('Выберите услугу'),
                        isExpanded: true,
                        // Для полного расширения кнопки по ширине
                        items: widget.services.keys
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
                            _controller.text =
                                widget.services[newValue].toString();
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
                        child: Form(
                          key: _serviceFormKey,
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
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == '0') {
                                return 'Некорректное\nзначение';
                              }
                              return null;
                            },
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
                BlocBuilder<FetchAppointmentsBloc, FetchAppointmentsState>(
                    builder: (context, allAppontmentsState) {
                  List<Appointment> appointments = [];

                  print(allAppontmentsState);
                  if (allAppontmentsState is FetchAppointmentsLoaded) {
                    appointments = allAppontmentsState.appointments;
                  }
                  appointments = appointments
                      .where((appo) =>
                          (appo.date.year == widget.curentDate.year &&
                              appo.date.month == widget.curentDate.month &&
                              appo.date.day == widget.curentDate.day))
                      .toList();

                  return ElevatedButton(
                    onPressed: () {
                      onConfirm((appointment) {
                        context.read<ActionsAppointmentBloc>().add(
                              UpdateAppointmentEvent(appointment: appointment),
                            );
                      }, (appointment) {
                        context.read<ActionsAppointmentBloc>().add(
                              CreateAppointmentEvent(appointment: appointment),
                            );
                      }, appointments);
                    },
                    child: const Text('Подтвердить'),
                  );
                }),
              ])),
    );
  }
}
