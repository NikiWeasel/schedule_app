import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/widgets/appo_dialog.dart';
import 'package:schedule_app/core/widgets/employee_profile_widget.dart';
import 'package:schedule_app/features/schedule/view/widgets/on_hold_dialog.dart';
import 'package:schedule_app/core/widgets/appointment_widget.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/widgets/person_header_widget.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/core/utils/vibration.dart';
import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';

class ScheduleTable extends StatefulWidget {
  const ScheduleTable(
      {super.key,
      required this.curentDate,
      required this.allEmployees,
      required this.allAppontments,
      required this.setEditAppoTable});

  final DateTime curentDate;
  final List<Employee> allEmployees;
  final List<Appointment> allAppontments;
  final void Function(
          void Function({Appointment? oldAppo, required Appointment newAppo}))
      setEditAppoTable;

  @override
  State<ScheduleTable> createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  Appointment? _oldAppo;
  late Appointment _newAppo;
  late Appointment _appoToDelete;

  final double timeSlotHeight =
      60.0; // Высота одного временного интервала (30 минут)

  final double timeSlotWidth = 210;

  late List<Appointment> tableAppos;
  late List<Appointment> allTableAppos;

  late Employee activeUser;

  void openEditingDialog(Appointment appointment) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return OnHoldDialog(
            curentDate: widget.curentDate,
            appointment: appointment,
            deleteAppoTable: setToDeleteAppoTableValue,
            editAppoTable: setAppoTableValues,
          );
        });
  }

  void setToDeleteAppoTableValue(Appointment appo) {
    _appoToDelete = appo;
  }

  void deleteAppoTable(Appointment appo) {
    setState(() {
      allTableAppos.remove(appo);
    });
  }

  void setAppoTableValues(
      {Appointment? oldAppo, required Appointment newAppo}) {
    _newAppo = newAppo;
    _oldAppo = oldAppo;
  }

  void editAppoTable({Appointment? oldAppo, required Appointment newAppo}) {
    if (oldAppo == null) {
      setState(() {
        allTableAppos.add(newAppo);
      });
    } else {
      setState(() {
        var index = allTableAppos.indexOf(oldAppo);
        allTableAppos.removeAt(index);
        allTableAppos.insert(index, newAppo);
      });
    }
  }

  void showAppoDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AppoDialog(appointment: appointment),
    );
  }

  @override
  void initState() {
    super.initState();
    activeUser = widget.allEmployees[0];
    allTableAppos = widget.allAppontments;
    // print
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.setEditAppoTable(setAppoTableValues);
    });

    var masters = widget.allEmployees;
    // var masters = allMasters
    //     .where((e) => widget.user.employeeId != e.employeeId)
    //     .toList();
    // masters.insert(0, widget.user);

    tableAppos = allTableAppos
        .where((appo) => (appo.date.year == widget.curentDate.year &&
            appo.date.month == widget.curentDate.month &&
            appo.date.day == widget.curentDate.day))
        .toList();

    return BlocListener<ActionsAppointmentBloc, ActionsAppointmentState>(
      listener: (context, state) {
        if (state is ActionsAppointmentLoadingState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Загрузка...');
        }
        if (state is ActionsAppointmentLoadedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Запись сделана!');
          print(_newAppo);
          editAppoTable(newAppo: _newAppo, oldAppo: null);
        }
        if (state is ActionsAppointmentUpdatedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Запись обновлена!');
          print(_newAppo);
          editAppoTable(newAppo: _newAppo, oldAppo: _oldAppo);
        }
        if (state is ActionsAppointmentDeletedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Запись удалена!');
          deleteAppoTable(_appoToDelete);
        }

        if (state is ActionsAppointmentErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Произошла ошибка: ${state.error}');
        }
      },
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Row(
                children: [
                  _buildTimeColumn(),
                  // ...masters.map((master) => _buildMasterColumn(master)),
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    IntrinsicWidth(child: _buildHeader(masters)),
                    Expanded(
                      child: Row(
                        children: [
                          ...masters.map((masterName) => _buildMasterColumn(
                              masterName.employeeId, tableAppos)),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(List<Employee> masters) {
    return Row(
      children: [
        Row(
          children: masters.map((master) {
            return Container(
                width: timeSlotWidth,
                // Ширина колонки для каждого мастера
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: MasterHeaderWidget(
                  title: '${master.name} ${master.surname}',
                  imageProvider: NetworkImage(master.imageUrl),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => EmployeeProfileWidget(
                              employee: master,
                              isAlwaysReadOnly: true,
                            ));
                  },
                ));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeColumn() {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Container(
          alignment: Alignment.center,
          width: 65,
          color: Theme.of(context)
              .colorScheme
              .surface, // Ширина для колонки времени
          child: const Text(
            'Время',
            style: TextStyle(fontWeight: FontWeight.bold),
          ), // Фиксированный фон
        ),
        const SizedBox(
          height: 28,
        ),
        Column(
          children: List.generate(21, (index) {
            final time =
                TimeOfDay(hour: 10 + (index ~/ 2), minute: (index % 2) * 30);
            return Container(
              width: 65,
              height: timeSlotHeight,
              alignment: Alignment.center,
              child: Text(
                time.format(context),
                style: index % 2 == 0
                    ? Theme.of(context).textTheme.bodyMedium
                    : Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5)),
              ),
            );
          }),
        ),
      ],
    );
  }

  // Колонка для мастера с записями
  Widget _buildMasterColumn(String master, List<Appointment> appointments) {
    return SizedBox(
      width: timeSlotWidth,
      child: Stack(
        children: [
          ..._buildTimeSlots(),
          ..._buildAppointmentsForMaster(master, appointments),
        ],
      ),
    );
  }

  // Стандартные ячейки для временных слотов
  List<Widget> _buildTimeSlots() {
    return List.generate(21, (index) {
      return Positioned(
        top: index * timeSlotHeight - timeSlotHeight / 2,
        left: 0,
        right: 0,
        child: Container(
          height: timeSlotHeight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
              right: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      );
    });
  }

  // Записи для конкретного мастера
  List<Widget> _buildAppointmentsForMaster(
      String masterId, List<Appointment> appointments) {
    return appointments
        .where((appointment) => appointment.masterId == masterId)
        .map((appointment) {
      final startMinutes =
          (appointment.date.hour - 10) * 60 + appointment.date.minute + 15;
      final topOffset = startMinutes / 30 * timeSlotHeight;
      final height = appointment.duration / 30 * timeSlotHeight;

      return Positioned(
          top: topOffset,
          left: 0,
          right: 0,
          child: AppointmentWidget(
            height: height - 8,
            appointment: appointment,
            onHold: (holdAppointment) {
              onHoldVibrate();
              if (activeUser.isAdmin ||
                  activeUser.employeeId == appointment.masterId) {
                openEditingDialog(holdAppointment);
              } else {
                showTopSnackBar(context, 'Нельзя редактировать чужие записи');
              }
            },
            onTap: (tapAppo) {
              showAppoDialog(tapAppo);
            },
          ));
    }).toList();
  }
}
