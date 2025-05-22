import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/core/utils/vibration.dart';
import 'package:schedule_app/core/widgets/appo_dialog.dart';
import 'package:schedule_app/core/widgets/appointment_widget.dart';
import 'package:schedule_app/core/widgets/employee_profile_widget.dart';
import 'package:schedule_app/core/widgets/person_header_widget.dart';
import 'package:schedule_app/features/schedule/view/widgets/on_hold_dialog.dart';

class ScheduleTable extends StatefulWidget {
  const ScheduleTable({
    super.key,
    required this.currentDate,
    required this.allEmployees,
    required this.allAppointments,
  });

  final DateTime currentDate;
  final List<Employee> allEmployees;
  final List<Appointment> allAppointments;

  @override
  State<ScheduleTable> createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  final double timeSlotHeight =
      60.0; // Высота одного временного интервала (30 минут)

  final double timeSlotWidth = 210;

  late List<Appointment> tableAppos;

  late Employee activeUser;

  void openEditingDialog(Appointment appointment) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return OnHoldDialog(
            curentDate: widget.currentDate,
            appointment: appointment,
          );
        });
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
  }

  @override
  Widget build(BuildContext context) {
    var masters = widget.allEmployees;

    tableAppos = widget.allAppointments
        .where((appo) => (appo.date.year == widget.currentDate.year &&
            appo.date.month == widget.currentDate.month &&
            appo.date.day == widget.currentDate.day))
        .toList();

    return SingleChildScrollView(
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
          child: Stack(
            children: [
              AppointmentWidget(
                height: height - 8,
                width: timeSlotWidth,
                appointment: appointment,
                onHold: (holdAppointment) {
                  onHoldVibrate();
                  if (activeUser.isAdmin ||
                      activeUser.employeeId == appointment.masterId) {
                    openEditingDialog(holdAppointment);
                  } else {
                    showTopSnackBar(
                        context, 'Нельзя редактировать чужие записи');
                  }
                },
                onTap: (tapAppo) {
                  showAppoDialog(tapAppo);
                },
              ),
              Positioned(
                  top: 7,
                  right: 7,
                  child: Transform.scale(
                      scale: 0.9,
                      child: const IgnorePointer(child: Icon(Icons.zoom_in))))
            ],
          ));
    }).toList();
  }
}
