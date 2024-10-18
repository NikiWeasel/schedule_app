import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/appointment_dialog/on_hold_dialog.dart';
import 'package:schedule_app/widgets/appointment_widget.dart';
import 'package:schedule_app/widgets/person_header_widget.dart';
import 'package:schedule_app/models/appointment.dart';
import 'package:schedule_app/widgets/appointment_dialog/editing_dialog.dart';

class ScheduleTable extends StatefulWidget {
  const ScheduleTable({super.key});

  @override
  State<ScheduleTable> createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  final List<String> masters = ['Мастер 1', 'Мастер 2', 'Мастер 3'];
  final double timeSlotHeight =
  60.0; // Высота одного временного интервала (30 минут)
  final List<Appointment> appointments = [
    Appointment('Мастер 1', 'Клиент 1', TimeOfDay(hour: 9, minute: 0),
        Duration(minutes: 45)),
    Appointment('Мастер 2', 'Клиент 2', TimeOfDay(hour: 10, minute: 30),
        Duration(minutes: 90)),
  ];

  void openEditingDialog() {
    showModalBottomSheet(
        context: context, builder: (ctx) => const OnHoldDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  IntrinsicWidth(child: _buildHeader()),
                  Expanded(
                    child: Row(
                      children: [
                        ...masters.map((master) => _buildMasterColumn(master)),
                      ],
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Row(
          children: masters.map((master) {
            return Container(
                width: 200,
                // Ширина колонки для каждого мастера
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: MasterHeaderWidget(
                  title: master,
                  onTap: () {},
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
          width: 80,
          color: Colors.white, // Ширина для колонки времени
          child: const Text(
            'Время',
            style: TextStyle(fontWeight: FontWeight.bold),
          ), // Фиксированный фон
        ),
        const SizedBox(
          height: 28,
        ),
        Column(
          children: List.generate(19, (index) {
            final time =
            TimeOfDay(hour: 9 + (index ~/ 2), minute: (index % 2) * 30);
            return Container(
              width: 80,
              height: timeSlotHeight,
              alignment: Alignment.center,
              child: Text(
                time.format(context),
                style: index % 2 == 0
                    ? Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    : Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                    color: Theme
                        .of(context)
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
  Widget _buildMasterColumn(String master) {
    return SizedBox(
      width: 200,
      child: Stack(
        children: [
          ..._buildTimeSlots(),
          ..._buildAppointmentsForMaster(master),
        ],
      ),
    );
  }

  // Стандартные ячейки для временных слотов
  List<Widget> _buildTimeSlots() {
    return List.generate(19, (index) {
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
  List<Widget> _buildAppointmentsForMaster(String master) {
    return appointments
        .where((appointment) => appointment.master == master)
        .map((appointment) {
      final startMinutes = (appointment.startTime.hour - 9) * 60 +
          appointment.startTime.minute +
          15;
      final topOffset = startMinutes / 30 * timeSlotHeight;
      final height = appointment.duration.inMinutes / 30 * timeSlotHeight;

      return Positioned(
          top: topOffset,
          left: 0,
          right: 0,
          child: AppointmentWidget(
            height: height - 8,
            appointment: appointment,
            onHold: openEditingDialog,
          ));
    }).toList();
  }
}
