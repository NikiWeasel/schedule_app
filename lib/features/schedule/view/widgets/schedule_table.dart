import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/app.dart';
import 'package:schedule_app/core/bloc/fetch/fetch_appointments_bloc.dart';
import 'package:schedule_app/core/widgets/employee_profile_widget.dart';
import 'package:schedule_app/features/schedule/bloc/all_employees_bloc.dart';
import 'package:schedule_app/features/schedule/view/widgets/on_hold_dialog.dart';
import 'package:schedule_app/core/widgets/appointment_widget.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/widgets/person_header_widget.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';

class ScheduleTable extends StatefulWidget {
  const ScheduleTable(
      {super.key, required this.curentDate, required this.user});

  final DateTime curentDate;
  final Employee user;

  @override
  State<ScheduleTable> createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  // final List<String> masters = ['Мастер 1', 'Мастер 2', 'Мастер 3'];
  final double timeSlotHeight =
      60.0; // Высота одного временного интервала (30 минут)

  final double timeSlotWidth = 210;

  void openEditingDialog(Appointment appointment) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => OnHoldDialog(
              appointment: appointment,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AllEmployeesBloc>(
          create: (context) => AllEmployeesBloc()..add(FetchAllEmployeesData()),
        ),
        BlocProvider<FetchAppointmentsBloc>(
          create: (context) =>
              FetchAppointmentsBloc()..add(FetchAppointmentsData()),
        ),
      ],
      child: BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
        builder: (context, allEmployeesState) {
          return BlocBuilder<FetchAppointmentsBloc, FetchAppointmentsState>(
            builder: (context, allAppontmentsState) {
              if ((allEmployeesState is AllEmployeesLoaded &&
                      allAppontmentsState is FetchAppointmentsLoaded) ||
                  (allEmployeesState is AllEmployeesLoaded)) {
                var allMasters = allEmployeesState.employees;
                var masters = allMasters
                    .where((e) => widget.user.employeeId != e.employeeId)
                    .toList();
                masters.insert(0, widget.user);

                List<Appointment> appointments = [];
                // print(allEmployeesState);
                // print(allAppontmentsState);
                if (allAppontmentsState is FetchAppointmentsError) {
                  debugPrint(allAppontmentsState.errorMessage);
                }

                if (allAppontmentsState is FetchAppointmentsLoaded) {
                  appointments = allAppontmentsState.appointments;
                }
                appointments = appointments
                    .where((appo) =>
                        (appo.date.year == widget.curentDate.year &&
                            appo.date.month == widget.curentDate.month &&
                            appo.date.day == widget.curentDate.day))
                    .toList();

                // print(appointments);
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
                                    ...masters.map((masterName) =>
                                        _buildMasterColumn(
                                            masterName.employeeId,
                                            appointments)),
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
              if (allEmployeesState is AllEmployeesError) {
                debugPrint(allEmployeesState.errorMessage);
              }
              if (allAppontmentsState is FetchAppointmentsError) {
                debugPrint(allAppontmentsState.errorMessage);
              }
              print(allEmployeesState);
              print(allAppontmentsState);

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
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
          children: List.generate(19, (index) {
            final time =
                TimeOfDay(hour: 9 + (index ~/ 2), minute: (index % 2) * 30);
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
  List<Widget> _buildAppointmentsForMaster(
      String masterId, List<Appointment> appointments) {
    return appointments
        .where((appointment) => appointment.masterId == masterId)
        .map((appointment) {
      final startMinutes = (appointment.getStartTimeHours() - 9) * 60 +
          appointment.getStartTimeMinutes() +
          15;
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
              openEditingDialog(holdAppointment);
            },
          ));
    }).toList();
  }
}
